require 'net/http'
require 'uri'

class GRequest
  attr_reader :search_word, :year, :month, :duration

  def initialize(search_word, year, month, duration=1)
    @search_word = search_word
    @year = year
    @month = month
    @duration = duration
  end
end

class GResult
  def initialize()
    @row_list = Array.new
  end

  def add(row)
    @row_list.push(row)
  end

  def getRows()
    return @row_list
  end

  def getRow(index)
    return @row_list[index]
  end

  def getSize()
    return @row_list.size
  end

  def toArray()
    array = Array.new
    results_array = getRows
    results_array.each do |row|
      array.push({ 'date' => row.date, 'number' => row.number })
    end
    return array
  end

  def printRows()
    results_array = getRows
    results_array.each do |row|
      puts "#{row.date}, #{row.number}"
    end
  end
    
  class GRow
    attr_reader :date, :number
    def initialize(date, number)
      @date = date
      @number = number
    end
  end
end

class GTrendManager
  
  def request(grequest)
    word = grequest.search_word
    month = grequest.month
    year = grequest.year
    duration = grequest.duration
    url = "http://www.google.com/trends/fetchComponent?hl=en&q=#{word}&date=#{month}/#{year}+#{duration}m&cmpt=q&content=1&cid=TIMESERIES_GRAPH_0&export=5&w=500&h=330"
    page_content = open(url)
    return parseContent(page_content)
  end
  
  def outputAsCsv(gresult, file_name)
    results_array = gresult.getRows()
    results_array.each do |row|
      File.open(file_name, 'a') {|f| f.puts("#{row.date}, #{row.number}\n") }
    end
  end
  
  def getResultAsArray(gresult)
    return gresult.toArray
  end

  def printResult(gresult)
    gresult.printRows
  end

  private
  def open(url)
    Net::HTTP.get(URI.parse(url))
  end

  def parseContent(page_content)
    results = GResult.new
    raw_data_array = page_content.split("rows\":")[1].split("var htmlChart").first
    split_raw = raw_data_array.split("],")
    split_raw.each do |sr|
      source = sr.split("Date(")[1].split(",")
      date = source[0]+'-'+(source[1].gsub(/\s/,"").to_i+1).to_s+'-'+source[2].gsub(/\s/,"").gsub(/\)\}/,"") 
      num = source[5]
      results.add(GResult::GRow::new(date, num))
    end
    return results
  end
end
