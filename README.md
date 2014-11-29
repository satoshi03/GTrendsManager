GTrendsManager
==============

Ruby library : Get response and return formatted data from Google Trends API

## Examples

Search word is AMAZON, searched results are created from 2012/10 to 2012/11

<pre>
gm = GTrendManager.new()
gresult = gm.request(GRequest.new("AMAZON", 2012, 10))
</pre>

Search words are AMAZON and Kindle, searched results are created from 2012/10 to 2013/01

<pre>
gm = GTrendManager.new()
gresult = gm.request(GRequest.new("AMAZON+Kindle", 2012, 10, 3))
</pre>

Display search result

<pre>
gm.printResult(gresult)
</pre>

output search result as csv file

<pre>
gm.outputAsCsv(gresult, "result_amazon.csv")
</pre>

convert search result to array(hash) and print it : Result is [ {"date"=>"2012-10-1", "number"=>"53"}, ... ]

<pre>
gm.getResultAsArray(gresult)
</pre>
