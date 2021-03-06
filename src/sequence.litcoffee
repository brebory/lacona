#Includes

	_ = require 'lodash'

	Group = require './group'

#Sequence

	class Sequence extends Group

###Constructor

		constructor: (options, factory) ->
			super options
For every child, push it and the separator (which defaults to ' ')

			{@value} = options
			@children = []
			for child in options.children
				@children.push(factory.create(child))
				@children.push(factory.create(options.separator ? ' ')) if options.separator isnt null

Remove the last separator, so that there is 1 separator between every child

			@children.pop() if options.separator isnt null

###Parse

		handleParse: (input, lang, context, data, done) ->
			parsesActive = 0

			parseChild = (childIndex, input) =>
				parsesActive++
				@children[childIndex].parse input, lang, context, (option) =>

					if childIndex is @children.length - 1
						newResult = option.handleValue(@id, @value)
						data(newResult)
					else
						parseChild(childIndex+1, option)
				, (err) =>
					if err?
						done(err)
					else
						parsesActive--
						if parsesActive is 0
							done()

			parseChild(0, input)



	module.exports = Sequence