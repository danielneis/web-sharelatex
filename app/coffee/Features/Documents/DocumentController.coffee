ProjectEntityHandler = require "../Project/ProjectEntityHandler"
Errors = require "../../errors"
logger = require("logger-sharelatex")

module.exports =
	getDocument: (req, res, next = (error) ->) ->
		project_id = req.params.Project_id
		doc_id = req.params.doc_id
		plain = req?.query?.plain == 'true'
		logger.log doc_id:doc_id, project_id:project_id, "receiving get document request from api (docupdater)"
		ProjectEntityHandler.getDoc project_id, doc_id, (error, lines, rev) ->
			if error?
				logger.err err:error, doc_id:doc_id, project_id:project_id, "error finding element for getDocument"
				return next(error)
			if plain
				res.type "text/plain"
				res.send lines.join('\n')
			else
				res.type "json"
				res.send JSON.stringify {
					lines: lines
				}

	setDocument: (req, res, next = (error) ->) ->
		project_id = req.params.Project_id
		doc_id = req.params.doc_id
		lines = req.body.lines
		logger.log doc_id:doc_id, project_id:project_id, "receiving set document request from api (docupdater)"
		ProjectEntityHandler.updateDocLines project_id, doc_id, lines, (error) ->
			if error?
				logger.err err:error, doc_id:doc_id, project_id:project_id, "error finding element for getDocument"
				return next(error)
			logger.log doc_id:doc_id, project_id:project_id, "finished receiving set document request from api (docupdater)"
			res.sendStatus 200

		
		
