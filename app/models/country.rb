class Country < ActiveRecord::Base

  has_many :states

  belongs_to :shipping_zone

  validates :name,  :presence => true,       :length => { :maximum => 200 }
  validates :abbreviation,  :presence => true,       :length => { :maximum => 10 }

  USA_ID    = 214
  CANADA_ID = 35
  UK_ID         = 213
  AUSTRALIA_ID  = 12

  after_save :expire_cache

  ACTIVE_COUNTRY_IDS = [ USA_ID ]
  DROPDOWN_COUNTRY_IDS = [ USA_ID, CANADA_ID, UK_ID, AUSTRALIA_ID ]

  # Call this method to display the country_abbreviation - country with and appending name
  #
  # @example abbreviation == USA, country == 'United States'
  #   country.abbreviation_name(': capitalist') => 'USA - United States : capitalist'
  #
  # @param [append name, optional]
  # @return [String] country abbreviation - country name
  def abbreviation_name(append_name = "")
    ([abbreviation, name].join(" - ") + " #{append_name}").strip
  end

  # Call this method to display the country_abbreviation - country
  #
  # @example abbreviation == USA, country == 'United States'
  #   country.abbrev_and_name => 'USA - United States'
  #
  # @param none
  # @return [String] country abbreviation - country name
  def abbrev_and_name
    abbreviation_name
  end

  def self.active
    where(:active => true)
  end
  # Finds all the countries for a form select .
  #
  # @param none
  # @return [Array] an array of arrays with [string, country.id]
  def self.form_selector
    Rails.cache.fetch("Country-form_selector") do
      data = Country.where(:active => true).order('abbreviation ASC').all().map { |c| [c.abbrev_and_name, c.id] }
      data.blank? ? [[]] : data
    end
  end

  def self.landing_page_form_selector
    Rails.cache.fetch("Landing_Page_Country-form_selector") do
      data = Country.order('abbreviation ASC').all().reject{|c| [DROPDOWN_COUNTRY_IDS].include?(c.id)}.map { |c| [c.abbrev_and_name, c.id] }
      data = Country.order('abbreviation DESC').find( DROPDOWN_COUNTRY_IDS ).map { |c| [c.abbrev_and_name, c.id] } + data
    end
  end
  private
  def expire_cache
    Rails.cache.delete("Country-form_selector")
  end
end
