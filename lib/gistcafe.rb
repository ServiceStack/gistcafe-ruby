require "gistcafe/version"

module Inspect

    class Error < StandardError; end

    def self.vars(args)
        inspect_vars_path = ENV["INSPECT_VARS"]
        return if args.nil? || inspect_vars_path.nil? || inspect_vars_path.empty? 
        json = JSON.generate(args)
        vars_path = inspect_vars_path.gsub('\\','/')
        if vars_path.index('/')
            Pathname.new(vars_path).dirname.mkpath
        end
        File.write(inspect_vars_path, json)
    end

    def self.dump(obj)
        json = JSON.pretty_generate(obj, { indent:'    '}).gsub('"','')
    end

    def self.print_dump(obj)
        puts dump(obj)
    end

    def self.to_list_map(rows)
        to = []
        rows.each do |row|
            if row.respond_to?(:to_hash)
                to.push(row.to_hash)
            else
                to.push(row.to_h)
            end
        end
        to
    end

    def self.all_keys(rows)
        to = []
        rows.each do |row|
            row.each do |k,v|
                if !to.include?(k)
                    to.push(k)
                end
            end
        end
        to
    end

    def self.dump_table(rows)
        return if rows.nil? || rows.empty?
        map_rows = to_list_map(rows)
        keys = all_keys(map_rows)
        col_sizes = {}

        keys.each do |k|
            max = k.length
            map_rows.each do |row|
                col = row[k]
                if !col.nil?
                    val_size = "#{col}".length
                    if val_size > max
                        max = val_size
                    end
                end
            end
            col_sizes[k] = max
        end

        col_sizes_length = col_sizes.length
        row_width = col_sizes.values.sum + (col_sizes_length * 2) + (col_sizes_length + 1)

        dashes = "-" * (row_width - 2)
        sb = []
        sb.push("+#{dashes}+")
        head = "|"
        keys.each do |k|
            head += "#{align_center(k, col_sizes[k])}|"
        end
        sb.push(head)
        sb.push("|#{dashes}|")

        map_rows.each do |row|
            to = "|"
            keys.each do |k|
                to += "#{align_auto(row[k], col_sizes[k])}|"
            end
            sb.push(to)
        end

        sb.push("+#{dashes}+")

        sb.join("\n")
    end

    def self.print_dump_table(obj)
        puts dump_table(obj)
    end

    def self.align_left(str, len, pad=" ")
        return "" if len < 0
        a_len = len + 1 - str.length
        return str if a_len <= 0
        "#{pad}#{str}#{pad * a_len}"
    end

    def self.align_center(str, len, pad=" ")
        return "" if len < 0
        str = "" if str.nil?
        n_len = str.length
        half = (len / 2.0 - n_len / 2.0).floor
        odds = ((n_len % 2) - (len % 2)).abs
        "#{pad * (half + 1)}#{str}#{pad * (half + 1 + odds)}"
    end

    def self.align_right(str, len, pad=" ")
        return "" if len < 0
        a_len = len + 1 - str.length
        return str if a_len <= 0
        "#{pad * a_len}#{str}#{pad}"
    end

    def self.align_auto(obj, len, pad=" ")
        str = "#{obj}"
        if str.length <= len
            if !Float(str, exception:false).nil?
                return align_right(str, len, pad)
            end
            return align_left(str, len, pad)
        end
        str
    end

end
