class AjaxsController < ApplicationController
	def index

	end

	def edit
		respond_to do |format|
			format.html
			format.json
			format.js
		end
	end
end
