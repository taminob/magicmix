extends abstract_dialogue

func init_statements():
	pass

func init_conversations():
	.init_conversations()
	pass

func init_partners():
	pass

func some_conversation() -> Array:
	var statement_name: String = "some"
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": "",
			"responses": [
				{
					"say": ""
				},
			],
		},
	}, [statement_name])
	return [statement_name, "start"]
