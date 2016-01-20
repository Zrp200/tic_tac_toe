module TicTacToe
  describe Game do
    let(:player_1)     { Human.new(name: 'Zaid', weapon: 'X') }
    let(:player_2)     { Human.new(name: 'Lahham', weapon: 'O') }
    let(:computer_1)   { Computer.new(name: 'Computer 1', weapon: 'X') }
    let(:computer_2)   { Computer.new(name: 'Computer 2', weapon: 'O') }
    let(:comp_players) { [computer_1, computer_2] }
    let(:game)         { Game.new([player_1, player_2]) }
    let(:cell)         { [0, 0] }

    context '#initialize' do
      it 'randomly selects a current_player' do
        allow_any_instance_of(Array).to receive(:shuffle).and_return([player_1, player_2])
        expect(game.current_player).to eq player_1
      end

      it 'randomly selects an other player' do
        allow_any_instance_of(Array).to receive(:shuffle).and_return([player_1, player_2])
        expect(game.other_player).to eq player_2
      end
    end

    context '#change_players' do
      it 'changes the players around' do
        other_player = game.other_player
        game.change_players
        expect(game.current_player).to eq other_player
      end

      it 'will set @other_player to @current_player' do
        current_player = game.current_player
        game.change_players
        expect(game.other_player).to eq current_player
      end
    end

    context '#ask_for_player_move' do
      it 'asks the player to make a move' do
        allow(game).to receive(:current_player) { player_1 }
        expect(game.ask_for_player_move).to eq "#{'Zaid'.blue}: Enter a number between 1 and 9 to make your move"
      end
    end

    context '#human_move' do
      context 'converts all moves to correct coords' do
        it { expect(game.human_move('1')).to eq [0, 0] }
        it { expect(game.human_move('2')).to eq [1, 0] }
        it { expect(game.human_move('3')).to eq [2, 0] }
        it { expect(game.human_move('4')).to eq [0, 1] }
        it { expect(game.human_move('5')).to eq [1, 1] }
        it { expect(game.human_move('6')).to eq [2, 1] }
        it { expect(game.human_move('7')).to eq [0, 2] }
        it { expect(game.human_move('8')).to eq [1, 2] }
        it { expect(game.human_move('9')).to eq [2, 2] }
      end

      it 'does not accept input outside the range 1-9' do
        allow(game).to receive(:human_move) { 'a' }
        expect(game.human_move('a')).to eq 'a'
      end

      it 'does not allow player to place choice in an occupied cell' do
        current_player = game.current_player
        game.human_move('1')
        game.change_players
        expect { game.human_move('1') }.not_to raise_error
        expect(game.other_player).to eq current_player
      end
    end

    context '#game_over_message' do
      it 'if there is a winner' do
        allow(game).to receive(:current_player) { player_1 }
        allow(game.board).to receive(:game_over) { :winner }
        expect(game.game_over_message).to eq "\nLahham won! Woohoooo!!!\n".red.back_light_blue
      end

      it 'if there is a draw' do
        allow(game).to receive(:current_player) { player_1 }
        allow(game.board).to receive(:game_over) { :draw }
        expect(game.game_over_message).to eq "\nThe game ended in a tie".colorize(:yellow)
      end
    end

    context '#play' do
      it 'computer should never lose' do
        game = TicTacToe::Game.new(comp_players)
        game.play
        expect(game.board.game_over).to eq :draw
      end
    end

    context '#integer_checker' do
      it 'accepts integers 1-9' do
        expect(game.integer_checker(1)).to eq 1
      end
    end

    context '#check_cell_occupied' do
      it 'returns cell if unoccupied' do
        expect(game.check_cell_occupied(cell)).to eq [0, 0]
      end
    end
  end
end
