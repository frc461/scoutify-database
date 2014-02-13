class MatchesController < ApplicationController
	before_action :set_match, only: [:show, :edit, :update, :destroy]

	# GET /matches
	# GET /matches.json
	def index
		@matches = params[:event_id] ? Match.where(event_id: params[:event_id]): Match.all
	end

	# GET /matches/1
	# GET /matches/1.json
	def show
	end

	# GET /matches/new
	def new
		@match = Match.new
	end

	# GET /matches/1/edit
	def edit
	end

	# POST /matches
	# POST /matches.json
	def create
		@match = Match.new(match_params)

		respond_to do |format|
			if @match.save
				format.html { redirect_to @match, notice: 'Match was successfully created.' }
				format.json { render action: 'show', status: :created, location: @match }
			else
				format.html { render action: 'new' }
				format.json { render json: @match.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /matches/1
	# PATCH/PUT /matches/1.json
	def update
		respond_to do |format|
			if @match.update(match_params)
				format.html { redirect_to @match, notice: 'Match was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @match.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /matches/1
	# DELETE /matches/1.json
	def destroy
		@match.destroy
		respond_to do |format|
			format.html { redirect_to matches_url }
			format.json { head :no_content }
		end
	end

	# GET /matches/1/tba_update
	def tba_update
		call_rake :update_match, :match_id => params[:id].to_i
		redirect_to "/matches/" + params[:id], notice: "Processing request."
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_match
		@match = Match.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def match_params
		params.require(:match).permit(:event_id, :match_number)
	end
end
