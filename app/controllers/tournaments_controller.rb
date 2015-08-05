class TournamentsController < ApplicationController

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
Result.find_by_sql("select Player_1A.id FROM results")
variable = 72
@results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = ? order by results.round, results.order", variable]
Result.all.where("(results.\"Player_1A_id\" = 28 or results.\"Player_2A_id\" = 28) and results.round = 1").first
# @results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.\"singles?\", results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = $1 order by results.round, results.order", [[columns["tournament_id"], variable]]]
@is_singles = Tournament.find(variable).singles?
end


private def update_elo_singles(id)

user = User.find(id)
if user.singles_total_games > 0

user.singles_rating = (user.singles_opponent_ratings + 400*(user.singles_total_wins - user.singles_total_losses))/user.singles_total_games
else
	user.singles_rating = 1000
end
user.save
return user.singles_rating


# redirect_to '/tournaments'


# # redirect_to '/tournaments'
end

private def update_elo_doubles(id)

user = User.find(id)
if user.doubles_total_games > 0
user.doubles_rating = (user.doubles_opponent_ratings + 400*(user.doubles_total_wins - user.doubles_total_losses))/user.doubles_total_games
else
	puts 'i shouldnt run'
	user.doubles_rating = 1000
end
user.save
return user.doubles_rating
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

# User.find(28).update(singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000)
# User.find(29).update(singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000)
# User.find(34).update(singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000)
# User.find(35).update(singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000)
# User.find(30).update(singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000)
# User.find(31).update(singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000)
# User.find(32).update(singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000)
# User.find(33).update(singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000)
	params[:user_id] = 30
	params[:prev] = 753
	params[:next] = 754

	winning_player = User.find(params[:user_id])

	prev_result = Result.find(params[:prev])
	next_result = Result.find(params[:next])



	if winning_player.id == prev_result.Player_1A_id
		losing_player = User.find(prev_result.Player_2A_id)
	else
		losing_player = User.find(prev_result.Player_1A_id)
	end
	t = Tournament.find(prev_result.tournament_id)
	if !validate_result(prev_result, next_result)
		results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = ? order by results.round, results.order", t.id]
    count = results.count
    render json: {results: results, count: count, error: 'Invalid move'}	
	else
		Result.find(prev_result.id).update(winner_A: winning_player)

	if t.game =='Ping Pong'

		total_wins = winning_player.singles_total_wins + 1
		total_games = winning_player.singles_total_games + 1
		opponent_ratings = winning_player.singles_opponent_ratings + losing_player.singles_rating
		winner_current_rating = winning_player.singles_rating
		User.find(winning_player.id).update(singles_total_wins: total_wins, singles_total_games: total_games, singles_opponent_ratings: opponent_ratings)

		total_losses = losing_player.singles_total_losses + 1
		total_games = losing_player.singles_total_games + 1
		opponent_ratings = losing_player.singles_opponent_ratings + winner_current_rating
		User.find(losing_player.id).update(singles_total_losses: total_losses, singles_total_games: total_games, singles_opponent_ratings: opponent_ratings)
		
		winning_player.singles_rating = update_elo_singles(winning_player.id)
		update_elo_singles(losing_player.id)


	end
	if next_result.low_seed == prev_result.low_seed
	next_result.Player_1A = winning_player
	puts winning_player.inspect
	next_result.Player_1A_rating = User.find(winning_player.id).singles_rating
	else
	next_result.Player_2A = winning_player	
	next_result.Player_2A_rating = User.find(winning_player.id).singles_rating
	end

	next_result.save
	prev_result.winner_A = winning_player
	prev_result.save


	if prev_result.low_seed ==1 && prev_result.high_seed ==2
		t = Tournament.find(prev_result.tournament_id)

		win_singles(prev_result)


	end
	results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = ? order by results.round, results.order", t.id]
    count = results.count
    render json: {results: results, count: count}	

end

	end

def win_lose_doubles
# User.find(28).update(doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)
# User.find(29).update(doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)
# User.find(34).update(doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)
# User.find(35).update(doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)
# User.find(30).update(doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)
# User.find(31).update(doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)
# User.find(32).update(doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)
# User.find(33).update(doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)
	params[:user_id_A] = 28
	params[:user_id_B] = 29
	
	winning_player_A = User.find(params[:user_id_A])
	winning_player_B = User.find(params[:user_id_B])
	prev_result = Result.find(params[:prev])
	next_result = Result.find(params[:next])


	if winning_player_A.id == prev_result.Player_1A_id
	losing_player_A = User.find(prev_result.Player_2A_id)
	losing_player_B = User.find(prev_result.Player_2B_id)

else
	losing_player_A = User.find(prev_result.Player_1A_id)
	losing_player_B = User.find(prev_result.Player_1B_id)
end
if !validate_result(prev_result, next_result)
results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = ? order by results.round, results.order", t.id]
    count = results.count
    render json: {results: results, count: count, error: 'Invalid move'}	
else
puts 'data 1'
puts winning_player_A.doubles_total_games
puts winning_player_B.doubles_total_games
puts losing_player_A.doubles_total_games
puts losing_player_B.doubles_total_games

	prev_result.winner_A = winning_player_A
	prev_result.winner_B = winning_player_B
	prev_result.save


t = Tournament.find(prev_result.tournament_id)
if t.game =='Ping Pong'
total_wins = winning_player_A.doubles_total_wins + 1
total_games = winning_player_A.doubles_total_games + 1
opponent_ratings = winning_player_A.doubles_opponent_ratings + ((losing_player_A.doubles_rating + losing_player_B.doubles_rating)/2)
winners_current_rating = (winning_player_A.doubles_rating + winning_player_B.doubles_rating)/2
User.find(winning_player_A.id).update(doubles_total_wins: total_wins, doubles_total_games: total_games, doubles_opponent_ratings: opponent_ratings)


total_wins = winning_player_B.doubles_total_wins + 1
total_games = winning_player_B.doubles_total_games + 1
opponent_ratings = winning_player_B.doubles_opponent_ratings + ((losing_player_A.doubles_rating + losing_player_B.doubles_rating)/2)

User.find(winning_player_B.id).update(doubles_total_wins: total_wins, doubles_total_games: total_games, doubles_opponent_ratings: opponent_ratings)



total_losses = losing_player_A.doubles_total_losses + 1
total_games = losing_player_A.doubles_total_games + 1
opponent_ratings = losing_player_A.doubles_opponent_ratings + winners_current_rating

User.find(losing_player_A.id).update(doubles_total_losses: total_losses, doubles_total_games: total_games, doubles_opponent_ratings: opponent_ratings)


total_losses = losing_player_B.doubles_total_losses + 1
total_games = losing_player_B.doubles_total_games + 1
opponent_ratings = losing_player_B.doubles_opponent_ratings + winners_current_rating

User.find(losing_player_B.id).update(doubles_total_losses: total_losses, doubles_total_games: total_games, doubles_opponent_ratings: opponent_ratings)



winning_player_A.doubles_rating = update_elo_doubles(winning_player_A.id)
winning_player_B.doubles_rating = update_elo_doubles(winning_player_B.id)
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

if prev_result.low_seed == 1 && prev_result.high_seed == 2
t = Tournament.find(prev_result.tournament_id)

win_doubles(prev_result)
	end
results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = ? order by results.round, results.order", t.id]
    count = results.count
    render json: {results: results, count: count}	

end
end

def undo_singles
	params[:user_id] = 30
	params[:prev] = 753
	params[:next] = 754

	prev_result = Result.find(params[:prev])
	next_result = Result.find(params[:next])

undo_user = User.find(params[:user_id])

t = Tournament.find(prev_result.tournament_id)
if t.game == 'Ping Pong'
if prev_result.Player_1A_id == undo_user.id
	rating = prev_result.Player_1A_rating
	opponent = User.find(prev_result.Player_2A.id)
	opponent_rating = prev_result.Player_2A_rating

else
rating = prev_result.Player_2A_rating
opponent = User.find(prev_result.Player_1A_id)
opponent_rating = prev_result.Player_1A_rating
	end
undo_user.singles_total_wins -= 1
undo_user.singles_total_games -= 1
undo_user.singles_opponent_ratings -= opponent_rating
opponent.singles_opponent_ratings -= rating
opponent.singles_total_losses -= 1
opponent.singles_total_games -= 1
undo_user.save
opponent.save
update_elo_singles(undo_user.id)
update_elo_singles(opponent.id)

end

prev_result.winner_A = nil

prev_result.save
if next_result.Player_1A_id == undo_user.id
	next_result.Player_1A = nil
	next_result.Player_1A_rating = nil

else
	next_result.Player_2A = nil
	next_result.Player_2A_rating = nil
end
next_result.save

if prev_result.low_seed ==1 && prev_result.high_seed ==2
Tournament.find(prev_result.tournament_id).update(winner_A: nil)


	end
	results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = ? order by results.round, results.order", t.id]
    count = results.count
    render json: {results: results, count: count}	
end

def undo_doubles


	params[:user_id_A] = 32
	params[:user_id_B] = 33
	params[:prev] = 723
	params[:next] = 725

	prev_result = Result.find(params[:prev])
	next_result = Result.find(params[:next])

undo_user_A = User.find(params[:user_id_A])
undo_user_B = User.find(params[:user_id_B])


t = Tournament.find(prev_result.tournament_id)



if t.game == 'Ping Pong'


if prev_result.Player_1A_id == undo_user_A.id
	rating_A = prev_result.Player_1A_rating
	rating_B = prev_result.Player_1B_rating
	ratings = (rating_A + rating_B)/2
	opponent_A = User.find(prev_result.Player_2A_id)
	opponent_B = User.find(prev_result.Player_2B_id)
	opponent_A_rating = prev_result.Player_2A_rating
	opponent_B_rating = prev_result.Player_2B_rating
	opponent_rating = (opponent_A_rating + opponent_B_rating)/2

else
rating_A = prev_result.Player_2A_rating
rating_B = prev_result.Player_2B_id_rating
ratings = (rating_A + rating_B)/2
opponent_A = User.find(prev_result.Player_1A_id)
opponent_B = User.find(prev_result.Player_1B_id)
opponent_rating_A = prev_result.Player_1A_rating
opponent_rating_B = prev_result.Player_1B_rating
opponent_rating = (opponent_rating_A + opponent_rating_B)/2


	end
puts undo_user_A.doubles_opponent_ratings
puts undo_user_A.name
puts undo_user_B.doubles_opponent_ratings
puts undo_user_B.name
puts opponent_A.doubles_opponent_ratings
puts opponent_B.doubles_opponent_ratings



puts 'checking A'
puts rating_A
puts rating_B
puts (rating_A + rating_B)/2
puts ratings
puts opponent_A.doubles_opponent_ratings
puts opponent_B.doubles_opponent_ratings
puts undo_user_A.doubles_opponent_ratings
puts undo_user_B.doubles_opponent_ratings
puts undo_user_A.doubles_opponent_ratings - opponent_rating
puts undo_user_A.inspect

doubles_total_wins = undo_user_A.doubles_total_wins - 1
doubles_total_games = undo_user_A.doubles_total_games - 1
doubles_opponent_ratings = undo_user_A.doubles_opponent_ratings - opponent_rating
User.find(undo_user_A.id).update(doubles_total_wins: doubles_total_wins, doubles_total_games: doubles_total_games, doubles_opponent_ratings: doubles_opponent_ratings)

doubles_total_wins = undo_user_B.doubles_total_wins - 1

doubles_total_games = undo_user_B.doubles_total_games - 1

doubles_opponent_ratings = undo_user_B.doubles_opponent_ratings - opponent_rating

User.find(undo_user_B.id).update(doubles_total_wins: doubles_total_wins, doubles_total_games: doubles_total_games, doubles_opponent_ratings: doubles_opponent_ratings)
doubles_opponent_ratings = opponent_A.doubles_opponent_ratings - ratings
doubles_total_losses = opponent_A.doubles_total_losses - 1
doubles_total_games = opponent_A.doubles_total_games - 1
User.find(opponent_A.id).update(doubles_total_losses: doubles_total_losses, doubles_total_games: doubles_total_games, doubles_opponent_ratings: doubles_opponent_ratings)
doubles_opponent_ratings = opponent_B.doubles_opponent_ratings - ratings

doubles_total_losses = opponent_B.doubles_total_losses - 1

doubles_total_games = opponent_B.doubles_total_games - 1
User.find(opponent_B.id).update(doubles_total_losses: doubles_total_losses, doubles_total_games: doubles_total_games, doubles_opponent_ratings: doubles_opponent_ratings)
# undo_user_A.save
# undo_user_B.save
# opponent_A.save
# opponent_B.save




puts 'checking'
puts undo_user_A.doubles_opponent_ratings
puts undo_user_B.doubles_opponent_ratings
puts opponent_A.doubles_opponent_ratings
puts opponent_B.doubles_opponent_ratings




update_elo_doubles(undo_user_A.id)
update_elo_doubles(undo_user_B.id)
update_elo_doubles(opponent_A.id)
update_elo_doubles(opponent_B.id)

puts 'checking D'
puts opponent_A.doubles_rating
puts opponent_B.doubles_rating
puts prev_result.Player_1A_rating
puts prev_result.Player_1B_rating
puts prev_result.Player_2A_rating
puts prev_result.Player_2B_rating
puts undo_user_A.doubles_rating
puts undo_user_B.doubles_rating



puts 'checking C'
puts undo_user_A.doubles_opponent_ratings
puts undo_user_B.doubles_opponent_ratings
puts opponent_A.doubles_opponent_ratings
puts opponent_B.doubles_opponent_ratings

end

prev_result.winner_A = nil
prev_result.winner_B = nil
prev_result.save
if next_result.Player_1A_id == undo_user_A.id
	next_result.Player_1A = nil
	next_result.Player_1B = nil
	next_result.Player_1A_rating = nil
	next_result.Player_1B_rating = nil

else
	next_result.Player_2A = nil
	next_result.Player_2B = nil
	next_result.Player_2A_rating = nil
	next_result.Player_2B_rating = nil
end
next_result.save
if prev_result.low_seed ==1 && prev_result.high_seed ==2
Tournament.find(prev_result.tournament_id).update(winner_A: nil, winner_B:nil)


	end
	results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = ? order by results.round, results.order", t.id]
    count = results.count
    render json: {results: results, count: count}	
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
		participant_1A = participants[low_seed-1].Player_A
		participant_1B = participants[low_seed-1].Player_B

		if participants[high_seed - 1] == nil
			participant_2A = bye_opponent
			participant_2B = bye_opponent
		else
		participant_2A = participants[high_seed-1].Player_A
		participant_2B = participants[high_seed-1].Player_B
		
		end
		puts 'start'
		puts participant_1A.doubles_rating
		puts participant_1B.doubles_rating
		puts participant_2A.doubles_rating
		puts participant_2B.doubles_rating
		Result.create(tournament: tournament, round: round, Player_1A: participant_1A, Player_1B: participant_1B, Player_2A: participant_2A, Player_2B: participant_2B, order: order, Player_1A_rating: participant_1A.doubles_rating, Player_1B_rating: participant_1B.doubles_rating, Player_2A_rating: participant_2A.doubles_rating, Player_2B_rating: participant_2B.doubles_rating, low_seed: low_seed, high_seed: high_seed)
	elsif i == 1
		round1_Team1 = Result.where(tournament: tournament, round: 1, low_seed: low_seed).includes(:Player_1A, :Player_1B).first

		round1_Team2 = Result.where(tournament: tournament, round: 1, low_seed: high_seed).includes(:Player_2A, :Player_2B).first
		round1_Player1A = round1_Team1.Player_1A
		round1_Player1B = round1_Team1.Player_1B
		round1_Player2A = round1_Team2.Player_1A
		round1_Player2B = round1_Team2.Player_1B
		if round1_Team1.Player_2A == bye_opponent
		bye_Player1 = true
	else bye_Player1 = false
	end




	if round1_Team2.Player_2A == bye_opponent
		bye_Player2 = true
	else bye_Player2 = false
	end
		if bye_Player1 && bye_Player2
Result.create(tournament: tournament, round: round, Player_1A: round1_Player1A, Player_1B: round1_Player1B, Player_2A: round1_Player2A, Player_2B: round1_Player2B, order: order, Player_1A_rating: round1_Player1A.doubles_rating, Player_1B_rating: round1_Player1B.doubles_rating,Player_2A_rating: round1_Player2A.doubles_rating, Player_2B_rating: round1_Player2B.doubles_rating,  low_seed: low_seed, high_seed: high_seed)
		elsif bye_Player1
Result.create(tournament: tournament, round: round, Player_1A: round1_Player1A, Player_1B: round1_Player1B,  order: order, Player_1A_rating: round1_Player1A.doubles_rating, Player_1B_rating: round1_Player1B.doubles_rating, low_seed: low_seed, high_seed: high_seed)
		
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

if participant == '' && existing_participants[index] == ''
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

if (participant == '' && existing_participants[index] == '') || (participants_B[index] == '' && existing_participants_B[index] == '')
	flash[:response] = 'Enter valid name for all users'
	redirect_to '/tournaments'
elsif (participant != '' && existing_participants[index] != '') || (participants_B[index] != '' && existing_participants_B[index] != '')

	flash[:response] = 'Choose existing user or create new one'
	redirect_to '/tournaments'
elsif existing_participants[index] != '' && existing_participants_B[index] != ''

elsif existing_participants[index] == '' && existing_participants_B[index] == ''


User.create(name: participants[index], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)

User.create(name: participants_B[index], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)

elsif existing_participants_B[index] == ''

User.create(name: participants_B[index], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)

else

	
	User.create(name: participants[index], singles_total_wins: 0, singles_total_losses: 0, singles_total_games: 0, singles_opponent_ratings: 0, singles_rating: 1000, doubles_total_wins: 0, doubles_total_losses: 0, doubles_total_games: 0, doubles_opponent_ratings: 0, doubles_rating: 1000)

	end



	

end
end





def destroy_user
u = User.find_by_name(params[:Name]).destroy
	end

def create_tournament

params[:existing_participants] =  ['', '', '', '']
params[:participants] = ['EE','FF', 'GG', 'HH']
params[:existing_participants_B] =  ['', '', '', '']
params[:participants_B] = ['II','JJ', 'KK', 'LL']
params[:Name] = 'MAB Classic'
params[:Game] = 'Ping Pong'
params[:Singles?] = 1
Result.all.where(tournament: Tournament.find_by_name('MAB Classic')).destroy_all
Participant.all.where(tournament: Tournament.find_by_name('MAB Classic')).destroy_all
Tournament.all.where(name: 'MAB Classic').destroy_all
t = Tournament.create(name: params[:Name], game: params[:Game], singles?: params[:Singles?], finished: 0)
if t.errors.any?
	flash[:errors] = t.errors.full_messages
else
	participants = params[:participants]
	

	existing_participants = params[:existing_participants]

	if params[:Singles?] == 1

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

			for i in 0...existing_participants.length
		if existing_participants[i] != ''

			participants[i] = existing_participants[i]
		end
	end
			for i in 0...existing_participants_B.length
			if existing_participants_B[i] != ''	
				participants_B[i] = existing_participants_B[i]
			end
		end


	end

	ranked_users = []
	counter = 1
	if params[:Singles?] == 1 && params[:Game] != 'Ping Pong'
		
		while participants.length > 0 do
		rand_var = rand(0..participants.length-1)
		Participant.create(tournament: Tournament.find(t.id), Player_A: User.find_by_name(participants[rand_var]), seed: counter)
		participants.delete_at(rand_var)
		counter += 1
		end
	elsif params[:Singles?] == 0 && params[:Game] != 'Ping Pong'




		while participants.length > 0 do
		rand_var = rand(0..participants.length-1)
	
		Participant.create(tournament: Tournament.find(t.id), Player_A: User.find_by_name(participants[rand_var]), Player_B: User.find_by_name(participants_B[rand_var]), seed: counter)
		participants.delete_at(rand_var)
		participants_B.delete_at(rand_var)
		counter += 1
		end
	elsif params[:Singles?] == 1 
			
		
		for i in 0..participants.length-1
		
			u = User.find_by_name(participants[i])
			ranked_users.push([u.singles_rating, u])
		end
		sorted_users = ranked_users.sort_by{|r| r[0]}.reverse!
		i = 0
		while true do
			the_seed = i + 1

			if i == sorted_users.length-1
				Participant.create(tournament: t, Player_A: sorted_users[i][1], seed: the_seed)
			
			elsif sorted_users[i][0] != sorted_users[i + 1][0]
				Participant.create(tournament: t, Player_A: sorted_users[i][1], seed: the_seed)
			
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

		sorted_users = ranked_users.sort_by{|r| r[0]}.reverse!
		i = 0

		while true do
				the_seed = i + 1

				if i == sorted_users.length-1
					Participant.create(tournament: t, Player_A: sorted_users[i][1], Player_B: sorted_users[i][2], seed: the_seed)
				
				elsif sorted_users[i][0] != sorted_users[i + 1][0]
					Participant.create(tournament: t, Player_A: sorted_users[i][1], Player_B: sorted_users[i][2], seed: the_seed)
				
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
						Participant.create(tournament: t, Player_A: sorted_users[same_values[rand_i]][1], Player_B: sorted_users[same_values[rand_i]][2], seed: the_seed)
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
results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = ? order by results.round, results.order", t.id]
    count = results.count
    render json: {results: results, count: count}		
end

end

def show_tournament
	@results = Result.where(tournament: t).order(:round, :seed).includes(:tournament, :Player_1A, :Player_2A)
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

	if params[:Singles?] == 1

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

			for i in 0...existing_participants.length
		if existing_participants[i] != ''

			participants[i] = existing_participants[i]
		end
	end
			for i in 0...existing_participants_B.length
			if existing_participants_B[i] != ''	
				participants_B[i] = existing_participants_B[i]
			end
		end


	end

	ranked_users = []
	counter = 1
	if params[:Singles?] == 1 && params[:Game] != 'Ping Pong'
		
		while participants.length > 0 do
		rand_var = rand(0..participants.length-1)
		Participant.create(tournament: Tournament.find(t.id), Player_A: User.find_by_name(participants[rand_var]), seed: counter)
		participants.delete_at(rand_var)
		counter += 1
		end
	elsif params[:Singles?] == 0 && params[:Game] != 'Ping Pong'




		while participants.length > 0 do
		rand_var = rand(0..participants.length-1)
	
		Participant.create(tournament: Tournament.find(t.id), Player_A: User.find_by_name(participants[rand_var]), Player_B: User.find_by_name(participants_B[rand_var]), seed: counter)
		participants.delete_at(rand_var)
		participants_B.delete_at(rand_var)
		counter += 1
		end
	elsif params[:Singles?] == 1 
			
		
		for i in 0..participants.length-1
		
			u = User.find_by_name(participants[i])
			ranked_users.push([u.singles_rating, u])
		end
		sorted_users = ranked_users.sort_by{|r| r[0]}.reverse!
		i = 0
		while true do
			the_seed = i + 1

			if i == sorted_users.length-1
				Participant.create(tournament: t, Player_A: sorted_users[i][1], seed: the_seed)
			
			elsif sorted_users[i][0] != sorted_users[i + 1][0]
				Participant.create(tournament: t, Player_A: sorted_users[i][1], seed: the_seed)
			
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

		sorted_users = ranked_users.sort_by{|r| r[0]}.reverse!
		i = 0

		while true do
				the_seed = i + 1

				if i == sorted_users.length-1
					Participant.create(tournament: t, Player_A: sorted_users[i][1], Player_B: sorted_users[i][2], seed: the_seed)
				
				elsif sorted_users[i][0] != sorted_users[i + 1][0]
					Participant.create(tournament: t, Player_A: sorted_users[i][1], Player_B: sorted_users[i][2], seed: the_seed)
				
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
						Participant.create(tournament: t, Player_A: sorted_users[same_values[rand_i]][1], Player_B: sorted_users[same_values[rand_i]][2], seed: the_seed)
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
results = Result.find_by_sql ["select distinct results.id as \"results_id\", results.round, results.low_seed, results.high_seed, results.\"Player_1A_id\", results.\"Player_1B_id\", results.\"Player_2A_id\", results.\"Player_2B_id\", results.\"winner_A_id\", results.\"winner_B_id\", results.order, results.\"Player_1A_rating\", results.\"Player_1B_rating\", results.\"Player_2A_rating\", results.\"Player_2B_rating\", player_1a.name as \"Player_1A_name\", player_1b.name as \"Player_1B_name\", player_2a.name as \"Player_2A_name\", player_2b.name as \"Player_2B_name\",  tournaments.name, tournaments.id, tournaments.game, tournaments.finished  FROM results inner join tournaments on results.tournament_id = tournaments.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1A_id\" = users.id) as player_1a on results.\"Player_1A_id\" = player_1a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_1B_id\" = users.id) as player_1b on results.\"Player_1B_id\" = player_1b.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2A_id\" = users.id) as player_2a on results.\"Player_2A_id\" = player_2a.id left outer join (select users.id, users.name from users inner join results on results.\"Player_2B_id\" = users.id) as player_2b on results.\"Player_2B_id\" = player_2b.id where results.\"tournament_id\" = ? order by results.round, results.order", t.id]
    count = results.count
    render json: {results: results, count: count}	
			
end

end



end
