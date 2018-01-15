class PrettyLog
    attr_accessor :data,:header, :max_lengths, :total_length, :string_format, :selected_fields
    SPACE = 1
    #### Instructions: ##############################################
    # to call to this function - PrettyLog.log(Hash,Array,String)
    # Hash - Data to print (required)
    # Array - Array of strings with the keys that wanted. (optional)
    # String - Header to print (optional)
    # Examples:
    #   PrettyLog.log({key_1: "Test value", key_2: "Another test value"},nil,"This is test")
    #   PrettyLog.log(User.last(10).as_json,["id","email"],"Last 10 users")
    #################################################################
    class << self         
        def log(data, selected_fields = nil ,header = nil)
            @data, @header, @selected_fields = data, header, selected_fields
            @data = [@data] if !@data.is_a?(Array)
            select_fields if @selected_fields.present?
            set_max_lengths
            set_format
            print
        end
        
        private

        def print
            to_print = ""
            to_print << add_header if @header.present?
            to_print << add_divider
            to_print << add_keys
            to_print << add_divider
            to_print << add_data
            to_print << add_divider
            Rails.logger.info(to_print)
        end
        
        def select_fields
            @data = @data.map{ |r| r.select{|k| @selected_fields.include? k}}
        end
            
        def set_max_lengths
            @max_lengths = {}
            @data.each do |r|
                check_length(r)
            end
            @total_length = @max_lengths.values.inject(0, :+) + ((@data[0].keys.length-1) * (SPACE + 2)) # 2 is the length of "| " dividers
            @total_length = @header.length > @total_length ? @header.length : @total_length if @header.present?
        end

        def check_length(row)
            row.each do |k,v|
                length = v.to_s.length > k.length ? v.to_s.length : k.length
                @max_lengths[k] = !@max_lengths[k] ? length : length > @max_lengths[k] ? length : @max_lengths[k]
            end
        end
        
        def set_format
            @string_format = @max_lengths.map { |k,v| "| %-#{v}s"}.join(" " * SPACE)
        end


        def add_header
            string = ""
            string << add_divider("=")
            string << "| " + @header.center(@total_length) + " |" << "\n"
            string << add_divider("=")
            string
        end
        
        def add_divider(divider = "-")
            "| " + "".center(@total_length,divider) + " |" + "\n"
        end

        def add_keys
            string = ""
            string << @string_format % @data[0].keys << add_right_border(string.length)  << "\n"
            string
        end

        def add_right_border(row_length)
            "".rjust((@total_length - row_length) +3) + "|"
        end

        def add_data
            table = ""
            @data.each_with_index do |d|
                string = ""
                string << @string_format % d.values << add_right_border(string.length) << "\n"
                table << string
            end
            table
        end
    end
end