module CrimeMapper
  CRIME_CODES = {
    '200' => 'ARSON',
    '13' => 'ASSAULT',
    '13A' => 'ASSAULT_AGGRAVATED',
    '13B' => 'ASSAULT_SIMPLE',
    '13C' => 'ASSAULT_INTIMIDATION',
    '510' => 'BRIBERY',
    '220' => 'BURGLARY',
    '250' => 'FORGERY',
    '290' => 'VANDALISM',
    '35' => 'DRUG',
    '35A' => 'DRUG_NARCOTICS',
    '35B' => 'DRUG_EQUIPMENT',
    '270' => 'EMBEZZLEMENT',
    '210' => 'EXTORTING',
    '26' => 'FRAUD',
    '26A' => 'FRAUD_SWINDLE',
    '26B' => 'FRAUD_CREDIT_CARD',
    '26C' => 'FRAUD_IMPERSONATION',
    '26D' => 'FRAUD_WELFARE',
    '26E' => 'FRAUD_WIRE',
    '39' => 'GAMBLING',
    '39A' => 'GAMBLING_BETTING',
    '39B' => 'GAMBLING_OPERATING',
    '39C' => 'GAMBLING_EQUIPMENT_VIOLATIONS',
    '39D' => 'GAMBLING_TAMPERING',
    '09' => 'HOMICIDE',
    '09A' => 'HOMICIDE_NONNEGLIGENT_MANSLAUGHTER',
    '09B' => 'HOMICIDE_NEGLIGENT_MANSLAUGHETER',
    '64' => 'HUMAN_TRAFFICKING',
    '64A' => 'HUMAN_TRAFFICKING_SEX_ACTS',
    '64B' => 'HUMAN_TRAFFICKING_INVOLUNTARY_SERVITUDE',
    '100' => 'KIDNAPPING',
    '23' => 'THEFT',
    '23A' => 'THEFT_POCKET_PICKING',
    '23B' => 'THEFT_PURSE_SNATCHING',
    '23C' => 'THEFT_SHOPLIFTING',
    '23D' => 'THEFT_FROM_BUILDING',
    '23E' => 'THEFT_FROM_THEFT_COINOPERATED_DEVICE',
    '23F' => 'THEFT_MOTOR_VEHICLE',
    '23G' => 'THEFT_MOTOR_VEHICLE_PARTS',
    '23H' => 'THEFT_OTHER',
    '240' => 'MOTOR_VEHICLE_THEFT',
    '370' => 'PORNOGRAPHY',
    '40' => 'PROSTITUTION',
    '40A' => 'PROSTITUTION',
    '40B' => 'PROSTITUTION_ASSISTANCE',
    '40C' => 'PROSTITUTION_PURCHASING',
    '120' => 'ROBBERY',
    '11' => 'SEX_OFFENSE',
    '11A' => 'SEX_OFFENSE_RAPE',
    '11B' => 'SEX_OFFENSE_SODOMY',
    '11C' => 'SEX_OFFENSE_ASSAULT_WITH_OBJECT',
    '11D' => 'SEX_OFFENSE_FONDLING',
    '36' => 'SEX_OFFENSE_NONFORCIBLE',
    '36A' => 'SEX_OFFENSE_NONFORCIBLE_INCEST',
    '36B' => 'SEX_OFFENSE_NONFORCIBLE_STATUATORY_RAPE',
    '280' => 'STOLEN_PROPERTY',
    '520' => 'WEAPON_LAW_VIOLATIONS',
    '90A' => 'BAD_CHECKS',
    '90B' => 'CURFEW',
    '90C' => 'DISORDERLY_CONDUCT',
    '90D' => 'DRIVING_UNDER_INFLUENCE',
    '90E' => 'DRUNKENNESS',
    '90F' => 'FAMILY_OFFENSES_NON_VIOLENT',
    '90G' => 'LIQUOR_LAW_VIOLATIONS',
    '90H' => 'PEEPING_TOM',
    '90I' => 'RUNAWAY',
    '90J' => 'TRESSPASSING',
    '90Z' => 'OTHER'
  }

  CRIME_CATEGORIES = {
    'PROPERTY': ['200', '510', '220', '250', '290', '270', '210', '26', '26A', '26B', '26C', '26D',
      '26E', '23', '23A', '23B', '23C', '23D', '23E', '23F', '23G', '23H', '240', '120', '280', '90A'],
    'PERSON': ['13', '13A', '13B', '13C', '09', '09A', '09B', '64', '64A', '64B', '100', '11', '11A',
      '11B', '11C', '11D', '36A', '36B'],
    'SOCIETY': ['35','35A', '35B', '39', '39A', '39B', '39C', '39D', '370', '40', '40A', '40B', '40C', '520',
      '90B', '90C', '90D', '90E', '90F', '90G', '90H', '90J']
  }

  def self.convert_crime_key_to_application_key(crime_counts)
    CRIME_CATEGORIES.inject({}) do |result, crime_category|
      crimes = crime_category[1].inject({}) do |crime_hash, crime|
        crime_hash.merge(CrimeMapper::CRIME_CODES[crime] => crime_counts[crime].to_i)
      end

      result.merge(crime_category[0] => crimes)
    end
  end
end
