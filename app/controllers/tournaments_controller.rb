class TournamentsController < ApplicationController
	skip_before_filter :verify_authenticity_token
def index

end


private def validate_result(prev_result, next_result)
bye_opponent = User.find_by_name('Bye')
if prev_result.round + 1 == next_result.round && (prev_result.low_seed == next_result.low_seed || prev_result.low_seed == next_result.high_seed) && prev_result.Player_2A_id != bye_opponent.id
return true
else return false
	end

end

def create_tests_singles

#create tournament
existing_participants = ['','','','','','']
participants = ['A', 'B', 'C', 'D', 'E', 'F']
t_name = 'May Classic'
t_game = 'Ping Pong'
singles = 0


end

def create_tests_doubles
existing_participants = ['','','','','','']
participants = ['A', 'B', 'C', 'D', 'E', 'F']
existing_participants_B = ['','','','','','']
participants_B = ['AA', 'BB', 'CC', 'DD', 'EE', 'FF']
t_name = 'May Classic'
t_game = 'Ping Pong'
singles = 1
end

private def notes
User.create(name: 'A', singles_total_wins: 1, singles_total_losses: 0, singles_total_games: 1, singles_opponent_ratings: 1000, singles_rating: 1000, doubles_total_wins: 1, doubles_total_losses: 0, doubles_total_games: 1, doubles_opponent_ratings: 1000, doubles_rating: 1000)
User.last.update(singles_total_wins: 10, singles_total_losses: 0, singles_total_games: 10, singles_opponent_ratings: 10000, singles_rating: 1000, doubles_total_wins: 1, doubles_total_losses: 0, doubles_total_games: 1, doubles_opponent_ratings: 1500, doubles_rating: 1000)
User.connection
Tournament.connection
Participant.connection
Result.connection	
Hirb.enable

end


private def update_elo_singles(id)

user = User.find(id)

user.singles_rating = (user.singles_opponent_ratings + 400*(user.singles_total_wins - user.singles_total_losses))/user.singles_total_games
user.save


redirect_to '/tournaments'


# redirect_to '/tournaments'
end

private def update_elo_doubles(id)

user = User.find(id)
user.doubles_rating = (user.doubles_opponent_ratings + 400*(user.doubles_total_wins - user.doubles_total_losses))/user.doubles_total_games
user.save
redirect_to '/tournaments'
end

def calculate_seeds(tournament_id)

participants = Participant.all.where(tournament_id: tournament_id).count
powers_2 = [1,2,4,8,16,32,64,128]
count = 0
	powers_2.each_with_index do |value, index|

	if participants <= value

		count = index
		
		break
	end

	end
	

arr = [[[1,1]], [[1, 2]]];

for i in 1...count
  
  arr.push([])
    for j in 0...arr[i].length
      
      arr[i + 1].push([arr[i][j][0], 2**(i + 1) - arr[i][j][0] + 1 ], [arr[i][j][1],  2**(i + 1) - arr[i][j][1] + 1])
      
  end
end
return arr.reverse!

end

private def win_singles(my_result)
Tournament.find(my_result.tournament_id).update(winner_A: User.find(my_result.winner_A_id))
end
private def win_doubles(my_result)
Tournament.find(my_result.tournament_id).update(winner_A: User.find(my_result.winner_A_id), winner_B: User.find(my_result.winner_B_id))
end

def submit_tournament
	Tournament.find(params[:id]).update(finished: 1)
	redirect_to '/tournaments'
	end

def win_lose_singles
	params[:user_id] = 4
	params[:prev] = 196
	params[:next] = 199

	winning_player = User.find(params[:user_id])

	prev_result = Result.find(params[:prev])
	next_result = Result.find(params[:next])

	prev_result.winner_A = winning_player
	prev_result.save

	if winning_player.id == prev_result.Player_1A_id
	losing_player = User.find(prev_result.Player_2A_id)
else
	losing_player = User.find(prev_result.Player_1A_id)
end
if !validate_result(prev_result, next_result)
		@response["error"] = 'Invalid Move'
		render :json => @response
else
Result.find(prev_result.id).update(winner_A: winning_player)
t = Tournament.find(prev_result.tournament_id)
if t.game =='Ping Pong'
total_wins = winning_player.singles_total_wins + 1
total_games = winning_player.singles_total_games + 1
opponent_ratings = winning_player.singles_opponent_ratings + losing_player.singles_rating
winner_current_rating = winning_player.singles_rating
User.find(winning_player.id).update(singles_total_wins: total_wins, singles_total_wins: total_games, singles_opponent_ratings: opponent_ratings)

total_wins = losing_player.singles_total_wins + 1
total_games = losing_player.singles_total_games + 1
opponent_ratings = losing_player.singles_opponent_ratings + winner_current_rating
User.find(losing_player.id).update(singles_total_wins: total_wins, singles_total_wins: total_games, singles_opponent_ratings: opponent_ratings)
update_elo_singles(winning_player.id)
update_elo_singles(losing_player.id)


end
if next_result.low_seed == prev_result.low_seed
next_result.Player_1A = winning_player
next_result.Player_1A_rating = winning_player.singles_rating
else
next_result.Player_2A = winning_player	
next_result.Player_2A_rating = winning_player.singles_rating
end

next_result.save

if prev_result.low_seed ==1 && prev_result.high_seed ==2
t = Tournament.find(prev_result.tournament_id)

win_singles(prev_result)


	end

end

	end

def win_lose_doubles

	winning_player_A = User.find(params[:user_id_A])
	winning_player_B = User.find(params[:user_id_B])
	prev_result = Result.find(parmas[:prev])
	next_result = Result.find(parmas[:next])

	prev_result.winner_A = winning_player_A
	prev_result.winner_B = winning_player_B
	prev_result.save

	if winning_player_A.id == prev_result.Player_1A_id
	losing_player_A = User.find(prev_result.Player_2A_id)
	losing_player_B = User.find(prev_result.Player_2B_id)

else
	losing_player_A = User.find(prev_result.Player_1A_id)
	losing_player_B = User.find(prev_result.Player_1B_id)
end
if !validate_result(prev_result, next_result)
		@response["error"] = 'Invalid Move'
		render :json => @response
else
Result.find(prev_result.id).update(winner_A: winning_player_A, winner_B: winning_player_B )
t = Tournament.find(prev_result.tournament_id)
if t.game =='Ping Pong'
total_wins = winning_player_A.doubles_total_wins + 1
total_games = winning_player_A.doubles_total_games + 1
opponent_ratings = winning_player_A.doubles_opponent_ratings + ((losing_player_A.doubles_rating + losing_player_B.doubles_rating)/2)
winners_current_rating = (winning_player_A.doubles_rating + winning_player_B.doubles_rating)/2
User.find(winning_player_A.id).update(doubles_total_wins: total_wins, doubles_total_wins: total_games, doubles_opponent_ratings: opponent_ratings)

total_wins = winning_player_B.doubles_total_wins + 1
total_games = winning_player_B.doubles_total_games + 1
opponent_ratings = winning_player_B.doubles_opponent_ratings + ((losing_player_A.doubles_rating + losing_player_B.doubles_rating)/2)

User.find(winning_player_B.id).update(doubles_total_wins: total_wins, doubles_total_wins: total_games, doubles_opponent_ratings: opponent_ratings)

total_wins = losing_player_A.doubles_total_wins + 1
total_games = losing_player_A.doubles_total_games + 1
opponent_ratings = winners_current_rating

User.find(losing_player_A.id).update(doubles_total_wins: total_wins, doubles_total_wins: total_games, doubles_opponent_ratings: opponent_ratings)

total_wins = losing_player_B.doubles_total_wins + 1
total_games = losing_player_B.doubles_total_games + 1

User.find(losing_player_B.id).update(doubles_total_wins: total_wins, doubles_total_wins: total_games, doubles_opponent_ratings: opponent_ratings)

update_elo_doubles(winning_player_A.id)
update_elo_doubles(winning_player_B.id)
update_elo_doubles(losing_player_A.id)
update_elo_doubles(losing_player_B.id)

end

if next_result.low_seed == prev_result.low_seed
next_result.Player_1A = winning_player_A
next_result.Player_1B = winning_player_B
next_result.Player_1A_rating = winning_player_A.doubles_rating
next_result.Player_1B_rating = winning_player_B.doubles_rating
else
next_result.Player_2A = winning_player_A	
next_result.Player_2B = winning_player_B	
next_result.Player_2A_rating = winning_player_A.doubles_rating
next_result.Player_2B_rating = winning_player_B.doubles_rating
end
next_result.save

if prev_result.low_seed ==1 && prev_result.high_seed ==2
t = Tournament.find(prev_result.tournament_id)

win_doubles(prev_result)
	end
end
end

def undo_singles

	prev_result = Result.find(parmas[:prev])
	next_result = Result.find(parmas[:next])

undo_user = User.find(params[:id])
prev_result.winner_A = nil

prev_result.save
if next_result.Player_1A_id == undo_user.id
	next_result.Player_1A = nil

else
	next_result.Player_2A = nil
end
t = Tournament.find(prev_result.tournament_id)
if t.game == 'Ping Pong'
if prev_result.Player_1A_id == undo_user.id
	rating = Player_1A_rating
	opponent = User.find(Player_2A.id)
	opponent_rating = Player_2A_rating

else
rating = Player_2A_rating
opponent = User.find(Player_1A.id)
opponent_rating = Player_1A_rating
	end
undo_user.singles_total_wins -= 1
undo_user.singles_total_games -= 1
undo_user.singles_opponent_ratings -= opponent_rating
opponent.singles_opponent_ratings -= rating
update_elo_singles(undo_user.id)
update_elo_singles(opponent.id)

end
if prev_result.low_seed ==1 && prev_result.high_seed ==2
Tournament.find(prev_result.tournament_id).update(winner_A: nil)


	end
end

def undo_doubles


	prev_result = Result.find(parmas[:prev])
	next_result = Result.find(parmas[:next])

undo_user_A = User.find(params[:user_A])
undo_user_B = User.find(params[:user_B])
prev_result.winner_A = nil
prev_result.winner_B = nil
prev_result.save
if next_result.Player_1A_id == undo_user_A.id
	next_result.Player_1A = nil
	next_result.Player_1B = nil

else
	next_result.Player_2A = nil
	next_result.Player_2B = nil
end
t = Tournament.find(prev_result.tournament_id)
if t.game == 'Ping Pong'
if prev_result.Player_1A_id == undo_user.id
	rating_A = Player_1A_rating
	rating_B = Player_1B_rating
	opponent_A = User.find(Player_2A.id)
	opponent_B = User.find(Player_2B.id)
	opponent_A_rating = prev_result.Player_2A_rating
	opponent_B_rating = prev_result.Player_2B_rating
	opponent_rating = (opponent_A_rating + opponent_B_rating)/2

else
rating_A = Player_2A_rating
rating_B = Player_2B_rating
opponent_A = User.find(Player_1A.id)
opponent_B = User.find(Player_1B.id)
opponent_rating_A = Player_1A_rating
opponent_rating_B = Player_1B_rating
opponent_rating = (opponent_A_rating + opponent_B_rating)/2
	end
undo_user_A.doubles_total_wins -= 1
undo_user_B.doubles_total_wins -= 1
undo_user_A.doubles_total_games -= 1
undo_user_B.doubles_total_games -= 1
undo_user_A.doubles_opponent_ratings -= opponent_rating
undo_user_B.doubles_opponent_ratings -= opponent_rating
opponent_A.doubles_opponent_ratings -= rating
opponent_B.doubles_opponent_ratings -= rating
update_elo_singles(undo_user_A.id)
update_elo_singles(undo_user_B.id)
update_elo_doubles(opponent_A.id)
update_elo_doubles(opponent_B.id)

end
if prev_result.low_seed ==1 && prev_result.high_seed ==2
Tournament.find(prev_result.tournament_id).update(winner_A: nil, winner_B:nil)


	end
end



private def generate_results_single(tournament_id)

participants = Participant.all.where(tournament: Tournament.find(tournament_id)).order(seed: :asc).includes(:Player_A, :Player_B)
seeds = calculate_seeds(tournament_id)

t = Tournament.find(tournament_id)
bye_opponent = User.find_by_name('Bye')
for i in 0...seeds.length
	for j in 0...seeds[i].length
		tournament = t
		low_seed = seeds[i][j][0]
		high_seed = seeds[i][j][1]
		round = i + 1
		order = j + 1
	
		if i == 0
			participant_1 = participants[low_seed-1].Player_A
			if participants[high_seed-1] == nil
				
				participant_2 = bye_opponent
			else
				participant_2 = participants[high_seed-1].Player_A
			end
		# puts 'participant 1'
		# puts participant_1.singles_rating
		# puts 'participant 2'
		# puts participant_2
			Result.create(tournament: tournament, round: round, Player_1A: participant_1, Player_2A: participant_2, order: order, Player_1A_rating: participant_1.singles_rating, Player_2A_rating: participant_2.singles_rating, low_seed: low_seed, high_seed: high_seed)
		elsif i == 1
			round1_Player1 = Result.where(tournament: tournament, round: 1, low_seed: low_seed).includes(:Player_1A).first
			round1_Player2 = Result.where(tournament: tournament, round: 1, low_seed: high_seed).includes(:Player_2A).first
			if round1_Player1.Player_2A == bye_opponent
				bye_Player1 = true
			else bye_Player1 = false
			end
		
			if round1_Player2.Player_2A == bye_opponent
				bye_Player2 = true
			else bye_Player2 = false
			end
			if bye_Player1 && bye_Player2
				Result.create(tournament: tournament, round: round, Player_1A: round1_Player1.Player_1A, Player_2A: round1_Player2.Player_1A, order: order, Player_1A_rating: round1_Player1.Player_1A.singles_rating, Player_2A_rating: round1_Player2.Player_1A.singles_rating, low_seed: low_seed, high_seed: high_seed)
			elsif bye_Player1
				Result.create(tournament: tournament, round: round, Player_1A: round1_Player1.Player_1A, order: order, Player_1A_rating: round1_Player1.Player_1A.singles_rating, low_seed: low_seed, high_seed: high_seed)
						
			else
				Result.create(tournament: tournament, round: round, order: order, low_seed: low_seed, high_seed: high_seed)
			end
		else
			Result.create(tournament: tournament, round: round, order: order, low_seed: low_seed, high_seed: high_seed)
		end


	end
end

end

private def generate_results_double(tournament_id)

participants = Participant.where(tournament: Tournament.find(tournament_id)).order(seed: :asc).includes(Player_1A, Player_1B, Player_2A, Player_2B)
seeds = calculate_seeds(tournament_id)
t = Tournament.find(tournament_id)
bye_opponent = User.find_by_name('Bye)')
for i in 0...seeds.length
	for j in 0...seeds[i].length
		tournament = t
		low_seed = seeds[i][j][0]
		high_seed = seeds[i][j][1]
		round = i + 1
		order = j + 1

		if i == 0
		participant_1A = participants[low_seed].Player_A
		participant_1B = participants[low_seed].Player_B
		if participants[high_seed] == nil
			participant_2A = bye_opponent
			participant_2B = bye_opponent
		else
			participant_2A = participants[high_seed].Player_A
			participant_2B = participants[high_seed].Player_B
		end
		Result.create(tournament: tournament, round: round, Player_1A: participant_1A, Player_1B: participant_1B, Player_2A: participant_2A, Player_2B: participant_2B, order: order, Player_1A_rating: participant_1A.doubles_rating, Player_1B_rating: participant_1B.doubles_rating, Player_2A_rating: participant_2A.doubles_rating, Player_2B_rating: participant_2B.doubles_rating, low_seed: low_seed, high_seed: high_seed)
	elsif i == 1
		round1_Team1 = Result.where(tournament: tournament, round: 1, low_seed: low_seed).includes(:Player_1A, :Player_1B).first
		round1_Player1A = round1_Team1.Player_1A
		round1_Player1B = round1_Team1.Player_1B
		round1_Player2A = round1_Team2.Player_1A
		round1_Player2B = round1_Team2.Player_1B
		if round1_Team1.Player_2A == bye_opponent
		bye_Player1 = true
	else bye_Player1 = false
	end
		round1_Team2 = Result.where(tournament: tournament, round: 1, low_seed: high_seed).includes(:Player_2A, :Player_2B).first



	if round1_Team2.Player_2A == bye_opponent
		bye_Player2 = true
	else bye_Player2 = false
	end
		if bye_Player1 && bye_Player2
Result.create(tournament: tournament, round: round, Player_1A: round1_Player1A, Player_2A: round1_Player2A, order: order, Player_1A_rating: round1_Player1A.doubles_rating, Player_2A_rating: round1_Player2A.doubles_rating, low_seed: low_seed, high_seed: high_seed)
		elsif bye_Player1
Result.create(tournament: tournament, round: round, Player_1A: round1_Player1A, order: order, Player_1A_rating: round1_Player1A.doubles_rating, low_seed: low_seed, high_seed: high_seed)
		
		else
Result.create(tournament: tournament, round: round, order: order, low_seed: low_seed, high_seed: high_seed)
	end
	else
Result.create(tournament: tournament, round: round, order: order, low_seed: low_seed, high_seed: high_seed)
	end


	end
end
end


private def create_users_singles(participants, existing_participants)

participants.each_with_index do |participant, index|

if participant == '' && existing_participants[index] = ''
	flash[:response] = 'Enter valid name for all users'
	redirect_to '/tournaments'
elsif participant != '' && existing_participants[index] != ''
	flash[:response] = 'Choose existing user or create new one'

elsif existing_participants[index] != ''



else

	
	u = User.create(name: participants[index], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000);

	end



	

end
end
#
private def create_users_doubles(participants, existing_participants, participants_B, existing_participants_B)

participants.each_with_index do |participant, index|

if (!participant && !existing_participants[index]) || (!participants_B && !existing_participants_B[index])
	flash[:response] = 'Enter valid name for all users'
	redirect_to '/tournaments'
elsif (participant && existing_participants[index]) || (participants_B && existing_participants_B[index])
	flash[:response] = 'Choose existing user or create new one'
	redirect_to '/tournaments'
elsif existing_participants[index] && existing_participants_B[index]

elsif existing_participants[index]

User.create(name: participants[index], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)

else

	
	User.create(name: participants_B[index], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)

	end



	

end
end





def destroy_user
u = User.find_by_name(params[:Name]).destroy
	end

def create_tournament

# params[:existing_participants] = ['','','','','','']
# params[:participants] = ['A', 'B', 'C', 'D', 'E', 'F']
# params[:Name] = 'MAB Classic'
# params[:Game] = 'Ping Pong'
# params[:Singles?] = 1
Result.all.where(tournament: Tournament.find_by_name('MAB Classic')).destroy_all
Participant.all.where(tournament: Tournament.find_by_name('MAB Classic')).destroy_all
Tournament.all.where(name: 'MAB Classic').destroy_all
t = Tournament.create(name: params[:Name], game: params[:Game], singles?: params[:Singles?], finished: 0)
if t.errors.any?
	render json: {errors: "invalid entries"}
else
	participants = params[:participants]
	

	existing_participants = params[:existing_participants]

	if params[:Singles?]

		create_users_singles(participants, existing_participants)
			for i in 0...existing_participants.length
		if existing_participants[i] != ''
			participants[i] = existing_participants[i]
		end
	end
	else
	participants_B = params[:participants_B]
	existing_participants_B = params[:existing_participants_B]

		create_users_doubles(participants, existing_participants, participants_B, existing_participants_B)

			for i in 0..existing_participants.length
		if existing_participants[i] != ''

			participants[i] = existing_participants[i]
		end
	end
			for i in 0..existing_participants_B.length
			if existing_participants_B[i] != ''	
				participants_B[i] = existing_participants_B[i]
			end
		end

	end

	ranked_users = []
	counter = 1
	if params[:Singles?] && params[:Game] != 'Ping Pong'
		
		while participants.length > 0 do
		rand_var = rand(0..participants.length-1)
		Participant.create(tournament: Tournament.find(t.id), Player_A: User.find_by_name(participants[rand_var]), seed: counter)
		participants.delete_at(rand_var)
		counter += 1
		end
	elsif !params[:Singles?] && params[:Game] != 'Ping Pong'
		
		while participants.length > 0 do
		rand_var = rand(0..participants.length-1)
		Participant.create(tournament: Tournament.find(t.id), Player_A: User.find_by_name(participants[rand_var]), Player_B: User.find_by_name(participants_B[rand_var]), seed: counter)
		participants.delete_at(rand_var)
		counter += 1
		end
	elsif params[:Singles?]
			
		for i in 0..participants.length-1
		
			u = User.find_by_name(participants[i])
			ranked_users.push([u.singles_rating, u])
		end
		sorted_users = ranked_users.sort_by{|r| r[0]}
		i = 0
		while true do
			the_seed = i + 1

			if i == sorted_users.length-1
				Participant.create(tournament: t, Player_A: sorted_users[i][1], seed: the_seed)
			
			elsif sorted_users[i][0] != sorted_users[i + 1][0]
				Participant.create(tournament: t, Player_A: sorted_users[i][1], seed: the_seed)
			
			else 
						puts 'mabi'
			puts i
				same_values = [i]

				for j in i+1...sorted_users.length
				if sorted_users[j][0] == sorted_users[i][0]
					same_values.push(j) 
				else break
				end
				end

				same_values_count = same_values.length
				while same_values.length >0 do
					rand_i = rand(0...same_values.length)
					Participant.create(tournament: t, Player_A: sorted_users[same_values[rand_i]][1], seed: the_seed)
					the_seed += 1
					same_values.delete_at(rand_i)
				end
				i += same_values_count -1

			end
				i += 1
			break if i >= sorted_users.length
		end
	else

		for i in 0...participants.length
			u_A = User.find_by_name(participants[i])
			u_B = User.find_by_name(participants_B[i])
			avg_rating = (u_A.doubles_rating + u_B.doubles_rating)/2
			ranked_users.push([avg_rating, u_A, u_B])
		end
		
		sorted_users = ranked_users.sort_by{|r| r[0]}
		i = 0
		while true do

			the_seed = i + 1
			if sorted_users[i + 1][0] != sorted_users[i + 1][0]
				Participant.create(tournament: Tournament.find(t.id), Player_A: sorted_users[i][1], Player_B: sorted_users[i][2],  seed: the_seed)
			else
				same_values = [i]

				for j in i+1...sorted_users.length
					if sorted_users[j][0] == sorted_users[i][0]
						same_values.push(j) 
					else break
					end
				end
				same_values_count = same_values.length
				while same_values.length >0 do
					rand_i = rand(0...same_values.length)
					Participant.create(tournament: Tournament.find(t.id), Player_A: sorted_users[same_values[rand_i]][1], Player_B: sorted_users[i][2],  seed: the_seed)
					the_seed += 1
					same_values.delete_at(rand_i)
				end
			i += same_values_count -1

			end
		 i += 1
		 break if i >= sorted_users.length
		end
	end
	
	if t.singles?
	
		 generate_results_single(t.id)
	else
		 generate_results_double(t.id)	
	
	end
	# names = []
	# results = Result.where(tournament_id: t.id).order(:round, :order).includes(:tournament, :Player_1A, :Player_2A)
	# result = Result.where(tournament_id: t.id).joins(:Player_1A)
	# result.each do |m|
	# 	names << m.Player_1A.name
	# end
	results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = ? order by results.round, results.order", t.id]
	count = results.count
	render json: {results: results, count: count}
	# render json: {valid: true}		
end

end

def update_tournament

t = Tournament.find(params[:id]).update(name: params[:Name], game: params[:Game], singles?: params[:Singles?], finished: params[:Finished])
if t.errors.any?
	flash[:errors] = t.errors.full_messages
else
	Participant.where(tournament: Tournament.find(params[:id])).destroy_all
	Result.where(tournament: Tournament.find(params[:id])).destroy_all
	participants = params[:participants]
	

	existing_participants = params[:existing_participants]

	if params[:Singles?]

		create_users_singles(participants, existing_participants)
			for i in 0...existing_participants.length
		if existing_participants[i] != ''
			participants[i] = existing_participants[i]
		end
	end
	else
	participants_B = params[:participants_B]
	existing_participants_B = params[:existing_participants_B]

		create_users_doubles(participants, existing_participants, participants_B, existing_participants_B)

			for i in 0..existing_participants.length
		if existing_participants[i] != ''

			participants[i] = existing_participants[i]
		end
	end
			for i in 0..existing_participants_B.length
			if existing_participants_B[i] != ''	
				participants_B[i] = existing_participants_B[i]
			end
		end

	end

	ranked_users = []
	counter = 1
	if params[:Singles?] && params[:Game] != 'Ping Pong'
		
		while participants.length > 0 do
		rand_var = rand(0..participants.length-1)
		Participant.create(tournament: Tournament.find(t.id), Player_A: User.find_by_name(participants[rand_var]), seed: counter)
		participants.delete_at(rand_var)
		counter += 1
		end
	elsif !params[:Singles?] && params[:Game] != 'Ping Pong'
		
		while participants.length > 0 do
		rand_var = rand(0..participants.length-1)
		Participant.create(tournament: Tournament.find(t.id), Player_A: User.find_by_name(participants[rand_var]), Player_B: User.find_by_name(participants_B[rand_var]), seed: counter)
		participants.delete_at(rand_var)
		counter += 1
		end
	elsif params[:Singles?]
			
		for i in 0..participants.length-1
		
			u = User.find_by_name(participants[i])
			ranked_users.push([u.singles_rating, u])
		end
		sorted_users = ranked_users.sort_by{|r| r[0]}
		i = 0
		while true do
			the_seed = i + 1

			if i == sorted_users.length-1
				Participant.create(tournament: t, Player_A: sorted_users[i][1], seed: the_seed)
			
			elsif sorted_users[i][0] != sorted_users[i + 1][0]
				Participant.create(tournament: t, Player_A: sorted_users[i][1], seed: the_seed)
			
			else 
						puts 'mabi'
			puts i
				same_values = [i]

				for j in i+1...sorted_users.length
				if sorted_users[j][0] == sorted_users[i][0]
					same_values.push(j) 
				else break
				end
				end

				same_values_count = same_values.length
				while same_values.length >0 do
					rand_i = rand(0...same_values.length)
					Participant.create(tournament: t, Player_A: sorted_users[same_values[rand_i]][1], seed: the_seed)
					the_seed += 1
					same_values.delete_at(rand_i)
				end
				i += same_values_count -1

			end
				i += 1
			break if i >= sorted_users.length
		end
	else

		for i in 0...participants.length
			u_A = User.find_by_name(participants[i])
			u_B = User.find_by_name(participants_B[i])
			avg_rating = (u_A.doubles_rating + u_B.doubles_rating)/2
			ranked_users.push([avg_rating, u_A, u_B])
		end
		
		sorted_users = ranked_users.sort_by{|r| r[0]}
		i = 0
		while true do

			the_seed = i + 1
			if sorted_users[i + 1][0] != sorted_users[i + 1][0]
				Participant.create(tournament: Tournament.find(t.id), Player_A: sorted_users[i][1], Player_B: sorted_users[i][2],  seed: the_seed)
			else
				same_values = [i]

				for j in i+1...sorted_users.length
					if sorted_users[j][0] == sorted_users[i][0]
						same_values.push(j) 
					else break
					end
				end
				same_values_count = same_values.length
				while same_values.length >0 do
					rand_i = rand(0...same_values.length)
					Participant.create(tournament: Tournament.find(t.id), Player_A: sorted_users[same_values[rand_i]][1], Player_B: sorted_users[i][2],  seed: the_seed)
					the_seed += 1
					same_values.delete_at(rand_i)
				end
			i += same_values_count -1

			end
		 i += 1
		 break if i >= sorted_users.length
		end
	end
	
	if t.singles?
	
		 generate_results_single(t.id)
	else
		 generate_results_double(t.id)	
	
	end


	redirect_to '/tournaments'	
			
end

end



end