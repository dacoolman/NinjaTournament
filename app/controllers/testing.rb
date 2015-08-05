class TournamentsController < ApplicationController

def index

end

private def update_elo_singles(id)

user = User.find(id)

user.singles_rating = (user.singles_opponent_ratings + 400*(user.singles_total_wins - user.singles_total_wins ))/user.singles_total_games


end

private def calculate_seeds(tournament_id)
participants = Participant.all.where(tournament_id: tournament_id).count
powers_2 = [1,2,4,8,16,32,64,128]
	powers_2.each_with_index do |value, index|
	if participants < value
		count = index -1
		break
	end
	
end


arr = [[[1,1]], [[1, 2]]];

for i in 1...count
  
  arr.push([])
    for j in 0...arr[i].length
      
      arr[i + 1].push([arr[i][j][0], 2**(i + 2) - arr[i][j][0] + 1 ], [arr[i][j][1],  2**(i + 2) - arr[i][j][1] + 1])
      
  end
end
return arr.reverse!
end

def win_lose_singles
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

private def win_singles(my_result)
Tournament.find(my_result.tournament_id).update(winner_A: User.find(my_result.winner_A_id))
end
private def win_doubles(my_result)
Tournament.find(my_result.tournament_id).update(winner_A: User.find(my_result.winner_A_id), winner_B: User.find(my_result.winner_B_id))
end
def submit_tournament
	Tournament.find(params[:tournament_id]).update(finished: 1)
	end

private def generate_results_single(tournament_id)
# powers_2 = [1,2,4,8,16,32,64,128]


# if powers_2.include? participants.length
# 	byes = 0
# else 
# 	differences = Array.new

# 	powers = 1
	
# 	while true
# powers *= 2
# if participants.length < powers
# byes = powers - participants.length
# break
# end
# 	end
participants = Participant.where(tournament: Tournament.find(tournament_id)).order(seed: :asc).includes(Player_1A, Player_2A)
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
		participant_1 = participants[low_seed].Player_A
		if participants[high_seed] == nil
			participant_2 = bye_opponent
		else
			participant_2 = participants[high_seed].Player_A
		end
		Result.create(tournament: tournament, round: round, Player_1A: participant_1, Player_2A: participant_2, order: order, Player_1A_rating: participant_1.singles_rating, Player_2A_rating: participant_2.singles_rating, low_seed: low_seed, high_seed: high_seed)
	elsif i == 1
		round1_Player1 = Result.where(tournament: tournament, round: 1, low_seed: low_seed).includes(:Player_1A).first
		if round1_Player1.Player_2A == bye_opponent
		bye_Player1 = true
	else bye_Player1 = false
		round1_Player2 = Result.where(tournament: tournament, round: 1, low_seed: high_seed).includes(:Player_2A).first
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
# finished = 0
# for i in 0...seeds[next_result.round -1].length
# for j in 0...seeds[i].length
# if seeds[i][j][0] == prev_result.low_seed 

# next_match = seeds[i][j][1]
# finished = 1
# break
# elsif seeds[i][j][1] == prev_result.low_seed 
# 	next_match = seeds[i][j][0]
# 	finished =1
# 	break
# end
# break if finished == 1

# 	end
	
# end

# for i in 0...participants.length

# if byes > 0

# Result.create(tournament: Tournament.find(tournament_id), round: 1, Player_1A: participant.Player_A, Player_2A: User.find_by_name('Bye'), winner_A: participant.Player_A)
# 	byes -= 1
	
# else
# Result.create(tournament: Tournament.find(tournament_id), round: 1, Player_1A: participants[0].Player_A, Player_2A: participants[participants.length-1].Player_A)

# end

	

# end
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
		if round1_Team1.Player_2A == bye_opponent
		bye_Player1 = true
	else bye_Player1 = false
	end
		round1_Team2 = Result.where(tournament: tournament, round: 1, low_seed: high_seed).includes(:Player_2A, :Player_2B).first
		round1_Player2A = round1_Team2.Player_1A
		round1_Player2B = round1_Team2.Player_1B


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

private def validate_result(prev_result, next_result)
bye_opponent = User.find_by_name('Bye')
if prev_result.round + 1 == next_result.round && (prev_result.low_seed == next_result.low_seed || prev_result.low_seed == next_result.high_seed) && prev_result.Player_2A_id != bye_opponent.id
return true
else return false
	end

end

private def update_elo_doubles

user = User.find(params[:id])
user.doubles_rating = (user.doubles_opponent_ratings + 400*(user.doubles_total_wins - user.doubles_total_wins ))/user.doubles_total_games
end
private def notes

User.connection
Tournament.connection
Participant.connection
Result.connection	
Hirb.enable

end

def create_user_singles
if !params[:Name]
@response["response_#{u.id}"] = 'Enter valid name'	
else
	u = User.find_by_name(params[:Name]).exists?
	@response = Hash.new
	if u
		
		@response["response_#{u.id}"] = 'User exists'
		render :json => @response
	else
		u = User.create(name: params[:Name], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000);
	@response["response_#{u.id}"] = u
	render :json => @response
	end
	

end
end

def create_users_doubles
if !params[:Name_A] || !params[:Name_B]
@response["response_#{u.id}"] = 'Enter valid names'	
else
	u_A = User.find_by_name(params[:Name_A]).exists?
	u_B = User.find_by_name(params[:Name_B]).exists?
	@response = Hash.new
	if u_A && u_B
		@response["response_#{u.id}_A"] = 'User A exists'
		@response["response_#{u.id}_B"] = 'User B exists'
	elsif u_A
		u_B = User.create(name: params[:Name_B], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000);
		@response["response_#{u.id}_A"] = 'User A exists'
		@response["response_#{u.id}_B"] = u_B
	elsif u_B
	u_A = User.create(name: params[:Name_A], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000);
	
	@response["response_#{u.id}_B"] = 'User B exists'
		
	else
		u_A = User.create(name: params[:Name_A], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000);
		u_B = User.create(name: params[:Name_B], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000);
	@response["response_#{u.id}"] = 'Users created'
	
	end
	render :json => @response
end
	end


def destroy_user
u = User.find_by_name(params[:Name]).destroy
	end

def create_tournament

t = Tournament.create(name: params[:Name], game: params[:Game], singles?: params[:Singles?], finished: 0)
if t.errors.any?
	flash[:errors] = t.errors.full_messages
	else
participants = params[:participants]
ranked_users = []
counter = 1
if params[:singles?] && params[:game] != 'Ping Pong'
while participants.length > 0 do
rand_var = rand(0..participants.length-1)
Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(participants[rand_var]), seed: counter)
participants.delete_at(rand_var)
counter += 1
end
elsif !params[:singles?] && params[:game] != 'Ping Pong'
	while participants.length > 0 do
rand_var = rand(0..participants.length-1)
Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(participants[rand_var][0].id), Player_B: User.find(participants[rand_var][1].id), seed: counter)
participants.delete_at(rand_var)
counter += 1
end
elsif params[:singles?]
for i in 0...participants.length
	u = User.find_by_name(participants[i].name)
	ranked_users.push([u.singles_rating, u])
end
sorted_users = ranked_users.sort_by{|r| r[0]}
for i in 0...sorted_users.length
	the_seed = i + 1
	if sorted_users[i + 1][0] != sorted_users[i + 1][0]
	Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[i][1].id), seed: the_seed)
else 
#beg
same_values = [i]

for j in i+1...sorted_users.length
if sorted_users[j][0] == sorted_users[i][0]
	same_values.push(j) 
else break
end
end
same_values_count = same_values.length
while same_values.length >0
rand_i = rand(0...same_values.length)
Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[same_values[rand_i]][1].id), seed: the_seed)
same_values.delete_at(rand_i)
end
i += same_values_count -1
	#end
end
end
else
	for i in 0...participants.length
	u_A = User.find_by_name(participants[i][0].name)
	u_B = User.find_by_name(participants[i][1].name)
	avg_rating = (u_A.doubles_rating + u_B.doubles_rating)/2
	ranked_users.push([avg_rating, u_A, u_B])
end
sorted_users = ranked_users.sort_by{|r| r[0]}
for i in 0...sorted_users.length
	the_seed = i + 1
	if sorted_users[i + 1][0] != sorted_users[i + 1][0]
	Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[i][1].id), Player_B: User.find(sorted_users[i][2].id),  seed: the_seed)
else
same_values = [i]

for j in i+1...sorted_users.length
if sorted_users[j][0] == sorted_users[i][0]
	same_values.push(j) 
else break
end
end
same_values_count = same_values.length
while same_values.length >0
rand_i = rand(0...same_values.length)
Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[same_values[rand_i]][1].id), Player_B: User.find(sorted_users[i][2].id),  seed: the_seed)
same_values.delete_at(rand_i)
end
i += same_values_count -1
end
end
if t.singles? == 1
 generate_results_single(t.id)
 else
 generate_results_double(t.id)	
 end

		redirect "tournament/#{t.id}"
	end

end

def update_tournament

t = Tournament.find(params[:id]).update(name: params[:Name], game: params[:Game], singles?: params[:Singles?], finished: params[:Finished])
if t.errors.any?
	flash[:errors] = t.errors.full_messages
	else
Participant.where(tournament: Tournament.find(params[:id])).destroy_all
participants = params[:participants]
ranked_users = []
counter = 1
if params[:singles?] && params[:game] != 'Ping Pong'
while participants.length > 0 do
rand_var = rand(0..participants.length-1)
Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(participants[rand_var]), seed: counter)
participants.delete_at(rand_var)
counter += 1
end
elsif !params[:singles?] && params[:game] != 'Ping Pong'
	while participants.length > 0 do
rand_var = rand(0..participants.length-1)
Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(participants[rand_var][0].id), Player_B: User.find(participants[rand_var][1].id), seed: counter)
participants.delete_at(rand_var)
counter += 1
end
elsif params[:singles?]
for i in 0...participants.length
	u = User.find_by_name(participants[i].name)
	ranked_users.push([u.singles_rating, u])
end
sorted_users = ranked_users.sort_by{|r| r[0]}
for i in 0...sorted_users.length
	the_seed = i + 1
	if sorted_users[i + 1][0] != sorted_users[i + 1][0]
	Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[i][1].id), seed: the_seed)
else 
#beg
same_values = [i]

for j in i+1...sorted_users.length
if sorted_users[j][0] == sorted_users[i][0]
	same_values.push(j) 
else break
end
end
same_values_count = same_values.length
while same_values.length >0
rand_i = rand(0...same_values.length)
Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[same_values[rand_i]][1].id), seed: the_seed)
same_values.delete_at(rand_i)
end
i += same_values_count -1
	#end
end
end
else
	for i in 0...participants.length
	u_A = User.find_by_name(participants[i][0].name)
	u_B = User.find_by_name(participants[i][1].name)
	avg_rating = (u_A.doubles_rating + u_B.doubles_rating)/2
	ranked_users.push([avg_rating, u_A, u_B])
end
sorted_users = ranked_users.sort_by{|r| r[0]}
for i in 0...sorted_users.length
	the_seed = i + 1
	if sorted_users[i + 1][0] != sorted_users[i + 1][0]
	Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[i][1].id), Player_B: User.find(sorted_users[i][2].id),  seed: the_seed)
else
same_values = [i]

for j in i+1...sorted_users.length
if sorted_users[j][0] == sorted_users[i][0]
	same_values.push(j) 
else break
end
end
same_values_count = same_values.length
while same_values.length >0
rand_i = rand(0...same_values.length)
Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[same_values[rand_i]][1].id), Player_B: User.find(sorted_users[i][2].id),  seed: the_seed)
same_values.delete_at(rand_i)
end
i += same_values_count -1
end
end
# participants = params[:participants]
# counter = 1
# if params[:singles?]
# while participants.length > 0 do
# rand_var = rand(0..participants.length-1)
# Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(participants[rand_var]), seed: counter)
# participants.delete_at(rand_var)
# counter += 1
# end
# else
# 	while participants.length > 0 do
# rand_var = rand(0..participants.length-1)
# Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(participants[rand_var][0]), Player_B: User.find(participants[rand_var][1]) seed: counter)
# participants.delete_at(rand_var)
# counter += 1
# end
# end
Result.where(tournament: Tournament.find(t.id)).destroy_all
if t.singles? == 1
 generate_results_single(t.id)
 else
 generate_results_double(t.id)	
 end
		redirect "tournament/#{t.id}"
	end

end



end


private def create_users_doubles_2
if !params[:Name_A] || !params[:Name_B]
@response["response_#{u.id}"] = 'Enter valid names'	
else
	u_A = User.find_by_name(params[:Name_A]).exists?
	u_B = User.find_by_name(params[:Name_B]).exists?
	@response = Hash.new
	if u_A && u_B
		@response["response_#{u.id}_A"] = 'User A exists'
		@response["response_#{u.id}_B"] = 'User B exists'
	elsif u_A
		u_B = User.create(name: params[:Name_B], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000);
		@response["response_#{u.id}_A"] = 'User A exists'
		@response["response_#{u.id}_B"] = u_B
	elsif u_B
	u_A = User.create(name: params[:Name_A], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000);
	
	@response["response_#{u.id}_B"] = 'User B exists'
		
	else
		u_A = User.create(name: params[:Name_A], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000);
		u_B = User.create(name: params[:Name_B], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000);
	@response["response_#{u.id}"] = 'Users created'
	
	end
	render :json => @response
end
def update_tournament
		participants = params[:participants]
	ranked_users = []
	counter = 1
	if params[:singles?] && params[:game] != 'Ping Pong'
		while participants.length > 0 do
			rand_var = rand(0..participants.length-1)
			Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(participants[rand_var]), seed: counter)
			participants.delete_at(rand_var)
			counter += 1
		end
	elsif !params[:singles?] && params[:game] != 'Ping Pong'
		while participants.length > 0 do
			rand_var = rand(0..participants.length-1)
			Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(participants[rand_var][0].id), Player_B: User.find(participants[rand_var][1].id), seed: counter)
			participants.delete_at(rand_var)
			counter += 1
		end
	elsif params[:singles?]
	
		for i in 0...participants.length
		u = User.find_by_name(participants[i].name)
		ranked_users.push([u.singles_rating, u])
		end

	sorted_users = ranked_users.sort_by{|r| r[0]}

		for i in 0...sorted_users.length
			the_seed = i + 1
			if sorted_users[i + 1][0] != sorted_users[i + 1][0]
				Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[i][1].id), seed: the_seed)
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
					Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[same_values[rand_i]][1].id), seed: the_seed)
					same_values.delete_at(rand_i)
				end
			i += same_values_count -1
		
			end
		end
	else
		for i in 0...participants.length
			u_A = User.find_by_name(participants[i][0].name)
			u_B = User.find_by_name(participants[i][1].name)
			avg_rating = (u_A.doubles_rating + u_B.doubles_rating)/2
			ranked_users.push([avg_rating, u_A, u_B])
		end

		sorted_users = ranked_users.sort_by{|r| r[0]}

		for i in 0...sorted_users.length
			the_seed = i + 1
			if sorted_users[i + 1][0] != sorted_users[i + 1][0]
				Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[i][1].id), Player_B: User.find(sorted_users[i][2].id),  seed: the_seed)
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
				Participant.create(tournament: Tournament.find(t.id), Player_A: User.find(sorted_users[same_values[rand_i]][1].id), Player_B: User.find(sorted_users[i][2].id),  seed: the_seed)
				same_values.delete_at(rand_i)
			end
			i += same_values_count -1
			end
		end
	end

	Result.where(tournament: Tournament.find(t.id)).destroy_all
	if t.singles? == 1
		generate_results_single(t.id)
	else
		generate_results_double(t.id)	
	end
end
	end

	#create sorted users for create tournament
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