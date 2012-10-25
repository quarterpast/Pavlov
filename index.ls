require \colors
require \sync
async = (.async!)

module.exports = class Describe
	pass: 0
	fail: 0
	function test-print {start,batch-name,test-name,topic,result,err}
		process.stdout.write if err? or not result then "  - #{test-name.red}" else "  + #{test-name.green}"
		process.stdout.write " [threw #that]".yellow if err?
		process.stdout.write " [returned #result]".magenta unless err!? and result
		process.stdout.write " (took #{Date.now! - start}ms)\n".grey
	(@suite,@batches)~>
		@others = []
		@suite-start = Date.now!
	and: ->@others.push it; this
	run: async ->
		console.log @suite.bold.underline.white
		suite-n = length @batches
		zip-with _,(keys @batches),(values @batches) <| (batch-name,batch)~>
			console.log " #batch-name:"
			{topic}:tests = if typeof! batch is \Function then batch! else batch
			topic = if typeof! topic is \Function then topic! else topic
			batch-n = (length tests)-1
			suite-n--
		
			zip-with _,(keys tests),(values tests) <| (test-name,test)~>
				return if test-name is \topic
				start = Date.now!

				if test.sync-me then test .= sync test,_

				if test is test.async! then test topic,test-cb
				else try result = test topic catch err finally test-cb err,result

				~function test-cb err,result
					if err? or not result then @fail++ else @pass++
					test-print {start,test-name,result,err}
					if --batch-n is 0 and suite-n is 0
						process.stdout.write "#{@suite.bold}: #{@pass.to-string!green} passed, #{@fail.to-string!red} failed"
						process.stdout.write " (took #{Date.now! - @suite-start}ms)\n".grey
		for suite in @others =>suite.run!

	@throws = (fn)->(topic)->
		try fn.sync null,topic
		catch => return yes
		finally  return no

	@expect = (val,fn, deep)->(import async:->this) (topic,cb)->
		console.log fn
		eq = if deep then (===) else (is)
		if fn.sync null,topic `eq` val then cb null,true
		else cb "failed expectation" val