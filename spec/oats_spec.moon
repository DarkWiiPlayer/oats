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

	it "parses one-line nodes", ->
		rose = {name: "person", {name: "name", "Rose"}, {name: "age", "22"}}
		assert.same {rose}, oats.decodefile("spec/fixtures/files/rose.oats")

	pending "parses inline nodes", ->
		document = {
			name: "document"
			{name: "title", "Document"}
			"Paragraph"
			"Multiline Paragraph"
			"Text with a"
			{name: "nested", "nested"}
			"node"
			"Text with an"
			{name: "nested"}
			"empty nested node"
		}
		assert.same {document}, oats.decodefile("spec/fixtures/files/document.oats")

	it "parses strings files", ->
		assert.same {{name: "tester"}}, oats.decode("[tester]")
		assert.same {{name: "tester", {name: "nested", "text"}}}, oats.decode("[tester]\n\t[nested] text")
	
	it "errors when indentation increases by more than one", ->
		assert.error ->
			oats.decode("[outer]\n\t\t[nested]")
	
	it "ignores empty lines", ->
		assert.same {{name: "tester", {name: "nested", "text"}}}, oats.decode("[tester]\n\n\t[nested] text")
