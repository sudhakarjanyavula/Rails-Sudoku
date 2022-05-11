class Api::SudokuController < ApplicationController
	def create
		begin
			d = eval(params[:d])
		rescue
			d = params[:d]
		end

		if solve_sudoku(d,0,0)
			render json: {solutions: d}
		else
			render json: {error: ["Not valid Sudoku"]}
		end
	end

	def validate_sudoku(data, row, col, num)
		for i in 0...9
			if data[row][i] == num
				return false
			end
		end
		for i in 0...9
			if data[i][col] == num
				return false
			end
		end
		start_row = row - row % 3
		start_col = col - col % 3
		for i in 0...3
			for j in 0...3
				if data[i + start_row][j + start_col] == num
					return false
				end
			end
		end
		return true
	end

	def solve_sudoku(data, row, col)
		n = 9
		if row == n - 1 && col == n
			return true
		end
		if col == n
			row = row +1
			col = 0
		end
		if !data[row][col].blank?
			return solve_sudoku(data, row, col + 1)
		end
		for num in 1..n
			if validate_sudoku(data, row, col, num)
				data[row][col] = num
				if solve_sudoku(data, row, col + 1)
					return true
				end
			end
			data[row][col] = nil
		end
		return false
	end
end


# [[5,4,nil,nil,2,nil,8,nil,6],
# [nil,1,9,nil,nil,7,nil,nil,3],
# [nil,nil,nil,3,nil,nil,2,1,nil],
# [9,nil,nil,4,nil,5,nil,2,nil],
# [nil,nil,1,nil,nil,nil,6,nil,4],
# [6,nil,4,nil,3,2,nil,8,nil],
# [nil,6,nil,nil,nil,nil,1,9,nil],
# [4,nil,2,nil,nil,9,nil,nil,5],
# [nil,9,nil,nil,7,nil,4,nil,2]]
