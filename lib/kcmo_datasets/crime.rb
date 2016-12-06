require 'socrata_client'
require 'crime_mapper'

module KcmoDatasets
  REGULAR_DATASOURCE_2014 = 'yu5f-iqbp'
  API_DATASOURCE_2014 = 'nsn9-g8a4'

  REGULAR_DATASOURCE_2015 = 'kbzx-7ehe'
  API_DATASOURCE_2015 = 'geta-wrqs'

  class Crime
    CRIME_SOURCE_2014_URI = 'https://data.kcmo.org/Crime/KCPD-Crime-Data-2014/yu5f-iqbp/'
    CRIME_SOURCE_2015_URI = 'https://data.kcmo.org/Crime/KCPD-Crime-Data-2015/kbzx-7ehe/'

    def initialize(neighborhood, options)
      @neighborhood = neighborhood
      @options = options
    end

    def fetch_metadata_2014
      @metadata_2014 ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/nsn9-g8a4/').response.body)
    rescue
      {}
    end

    def fetch_metadata_2015
      @metadata_2015 ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/geta-wrqs/').response.body)
    rescue
      {}
    end

    def query_data
      beginning_date = parse_date(@options[:start_data])
      end_date = parse_date(@options[:end_date])

      crime = []

      if beginning_date || end_date
        if beginning_date.try(&:year) == 2014 || end_date.try(&:year) == 2014
          crime << query(API_DATASOURCE_2014).each do |crime|
            crime['dataset_year'] = 2014
            crime['source'] = CRIME_SOURCE_2014_URI
            crime['last_updated'] = fetch_metadata_2014['viewLastModified']
          end
        end

        if beginning_date.try(&:year) == 2015 || end_date.try(&:year) == 2015
          crime << query(API_DATASOURCE_2015).each do
            crime['dataset_year'] = 2014
            crime['source'] = CRIME_SOURCE_2015_URI
            crime['last_updated'] = fetch_metadata_2015['viewLastModified']
          end
        end
      else
        crime << query(API_DATASOURCE_2014).each do |crime|
          crime['dataset_year'] = 2014
          crime['source'] = CRIME_SOURCE_2014_URI
          crime['last_updated'] = fetch_metadata_2014['viewLastModified']
        end

        crime << query(API_DATASOURCE_2015).each do |crime|
          crime['dataset_year'] = 2015
          crime['source'] = CRIME_SOURCE_2015_URI
          crime['last_updated'] = fetch_metadata_2015['viewLastModified']
        end
      end

      crime.flatten
    end

    def grouped_totals
      query = "SELECT ibrs, count(ibrs) WHERE #{@neighborhood.within_polygon_query('location_1')} GROUP BY ibrs"

      crimes = SocrataClient.get(API_DATASOURCE_2015, query)

      crime_counts = crimes.inject({}) {|crime_hash, crime|
        crime_hash.merge(crime['ibrs'] => crime['count_ibrs'])
      }

      crime_counts
    end

    private

    def query(data_source)
      SocrataClient.get(data_source, build_socrata_query)
    end

    def build_socrata_query
      query = "SELECT * WHERE #{@neighborhood.within_polygon_query('location_1')}"

      beginning_date = parse_date(@options[:start_data])
      end_date = parse_date(@options[:end_date])
      crime_codes = @options[:crime_codes] || []

      if beginning_date && end_date
        query += " AND #{filter_dates(start_date, end_date)}"
      end

      if crime_codes.present?
        query += " AND #{process_crime_filters(crime_codes)}"
      end

      query
    end

    def filter_dates(start_date, end_date)
      "from_date between '#{start_date.iso8601[0...-6]}' and '#{end_date.iso8601[0...-6]}'"
    end

    def process_crime_filters(crime_codes)
      if crime_codes.present?
        crime_code_filter = crime_codes.join("' OR ibrs='")
        "(ibrs = '#{crime_code_filter}')"
      else
        ""
      end
    end

    def parse_date(date)
      DateTime.parse(date)
    rescue
      nil
    end
  end
end