oats = require "oats"

describe "OATS", ->
	it "parses a basic file", ->
		assert.same {{name: "person", {name: "name"}, {name: "age"}}}, oats.decodefile("spec/fixtures/files/basic.oats")
		deep = {
			name: "first"
			{
				name: "second"
				{ name: "third" }
			}
			{
				name: "second",
				{ name: "third" }
				{ name: "third" }
			}
		}
		assert.same {deep}, oats.decodefile("spec/fixtures/files/deep.oats")
	
	it "parses basic text nodes", ->
		bob = {name: "person", {name: "name", "Bob"}, {name: "age", "20"}}
		assert.same {bob}, oats.decodefile("spec/fixtures/files/bob.oats")
	
	it "parses multiple lines into separate nodes", ->
		assert.same {"multi", "line", "strings"}, oats.decodefile("spec/fixtures/files/multi.oats")

	it "parses one-line nodes", ->
		rose = {name: "person", {name: "name", "Rose"}, {name: "age", "22"}}
		assert.same {rose}, oats.decodefile("spec/fixtures/files/rose.oats")

	it "parses inline nodes", ->
		document = {
			name: "document"
			{
				name: "section"
				"Text with a "
				{name: "inline", "inline"}
				" node"
				"Text with an "
				{name: "inline"}
				" empty nested node"
				{name: "one-line", "with ", {name: "inline"}, " node"}
			}
		}
		assert.same document, oats.decodefile("spec/fixtures/files/document.oats")[1]
	
	it "errors for endless inline nodes", ->
		assert.has.error (-> oats.decode("line with [endless tag")), "Endless inline tag on 1:11"

	it "parses strings files", ->
		assert.same {{name: "tester"}}, oats.decode("[tester]")
		assert.same {{name: "tester", {name: "nested", "text"}}}, oats.decode("[tester]\n\t[nested] text")
	
	it "errors when indentation increases by more than one", ->
		assert.error ->
			oats.decode("[outer]\n\t\t[nested]")
	
	it "ignores empty lines", ->
		assert.same {{name: "tester", {name: "nested", "text"}}}, oats.decode("[tester]\n\n\t[nested] text")
