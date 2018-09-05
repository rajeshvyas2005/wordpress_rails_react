# vim: foldmethod=marker tabstop=2 shiftwidth=2 autoindent
# coding: utf-8
module Util
  TIME_FILE_PATH = '.time'
  DATE_FORMAT     = '%Y-%m-%d'
  TIME_FORMAT     = '%H:%M:%S'
  DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S'
  DATEHHMM_FORMAT = '%Y-%m-%d %H:%M'

  def self.now
    @time = Time.zone.now
    if Rails.env.development? || Rails.env.test? || Rails.env == 'staging'
      if File.exist?(TIME_FILE_PATH)
        str = File.read(TIME_FILE_PATH, :encoding => Encoding::UTF_8)
        if !str.gsub(/(\r\n|\r|\n)/, '').blank?
          # YYYY-MM-DD hh:mm:ss (local)
          @time = Time.zone.local(str[0..3].to_i, str[5..6].to_i, str[8..9].to_i,
                                  str[11..12].to_i, str[14..15].to_i, str[17..18].to_i)
        end
      end
    end
    @time
  end

  def self.date_format(date, format = DATE_FORMAT)
    date.strftime(format) unless date.nil?
  end

  def self.time_format(time, format = TIME_FORMAT)
    time.strftime(format) unless time.nil?
  end

  def self.datetime_format(datetime, format = DATETIME_FORMAT)
    datetime.strftime(format) unless datetime.nil?
  end

  # Show date format YYYY-MM-DD HH:SS
  def self.datehhmm_format(datetime, format = DATEHHMM_FORMAT)
    datetime.strftime(format) unless datetime.nil?
  end

  def self.now_date(format = DATE_FORMAT)
    Util.now.strftime(format)
  end

  def self.utc_date(format = DATE_FORMAT)
    Util.now.to_s(:db).strftime(format)
  end

  def self.now_time(format = TIME_FORMAT)
    Util.now.strftime(format)
  end

  def self.utc_time(format = TIME_FORMAT)
    Util.now.to_s(:db).strftime(format)
  end

  def self.now_datetime(format = DATETIME_FORMAT)
    Util.now.strftime(format)
  end

  def self.utc_datetime(format = DATETIME_FORMAT)
    Util.now.to_s(:db).strftime(format)
  end
  # }}}
end
