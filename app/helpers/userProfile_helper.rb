module UserProfileHelper

    def formatted_duration(total_seconds)
        total_seconds = total_seconds.round # to avoid fractional seconds potentially compounding and messing up seconds, minutes and hours
        years = total_seconds / (3600 * 24 * 30 * 12)
        months = total_seconds / (3600 * 24 * 30)
        days = total_seconds / (3600 * 24)
        hours = total_seconds / (60*60) % 24
        minutes = (total_seconds / 60) % 60 # the modulo operator (%) gives the remainder when leftside is divided by rightside. Ex: 121 % 60 = 1
        seconds = total_seconds % 60
        # [months, days, hours, minutes, seconds].map do |t|
        #   # Right justify and pad with 0 until length is 2. 
        #   # So if the duration of any of the time components is 0, then it will display as 00
        #   t.round.to_s.rjust(2,'0')
        # end# .join(':')
        "#{years > 0? "#{years} month#{years > 1 ? "s" : ""},": ""}
        #{months > 0? "#{months} month#{months > 1 ? "s" : ""},": ""}
        #{days > 0? "#{days - (months * 30)} day#{days - (months * 30) > 1 ? "s" : ""},": ""}
        #{hours > 0? "#{hours}h": ""}
        #{minutes}min#{minutes - (hours * 60) > 1 ? "s" : ""}"
    end

end