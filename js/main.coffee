buildBoard = ->
  [0..3].map -> [0..3].map -> 0


randomInt = (x) ->
  Math.floor(Math.random() * x)


randomCellIndices = ->
  [randomInt(4), randomInt(4)]


randomValue = ->
  values = [2,2,2,4]
  values[randomInt(4)]


generateTile = (board) ->
  value = randomValue()
  [row, col] = randomCellIndices()
  # console.log "row: #{row} / col: #{col}"

  if board[row][col] is 0
    board[row][col] = value
  else
    generateTile(board)
    # console.log "generate tile"

move = (board, direction) ->
  #1 create new cloned empty board array
  newBoard = buildBoard()

  if direction in ["right", "left"]
    for i in [0..3]
      row = getRow(i, board)
      row = mergeCells(row, direction)
      row = collapseCells(row, direction)
      setRow(row, i, newBoard)
  else if direction in ["down", "up"]
    for i in [0..3]
      column = getColumn(i, board)
      column = mergeCells(column, direction)
      column = collapseCells(column, direction)
      setColumn(column, i, newBoard)
  else if direction is "x"
    for i in [0..3]
      #2 clone board with for, for loop
      row = getRow(i, board)
      setRow(row, i, newBoard)

      #3 swap corners
    newBoard = xCornerSwitch(newBoard)

  console.log("newBoard")
  printArray(newBoard)
  newBoard


xCornerSwitch = (board) ->
  # extract values of corners
  oldTopLeft = board[0][0]
  oldTopRight = board[0][3]
  oldBotLeft = board[3][0]
  oldBotRight = board[3][3]

  # exchange corners
  board[0][0] = oldBotRight #topLeft
  board[0][3] = oldBotLeft #topRight
  board[3][0] = oldTopRight #botLeft
  board[3][3] = oldTopLeft #botRight

  # return new xBoard
  board

getRow = (r, board) ->
  [board[r][0], board[r][1], board[r][2], board[r][3]]

setRow = (row, index, board) ->
  board[index] = row


getColumn = (c, board) ->
  [board[0][c], board[1][c], board[2][c], board[3][c]]

setColumn = (column, index, board) ->
  for i in [0..3]
    board[i][index] = column[i]


mergeCells = (cells, direction) ->

  merge = (cells) ->
    for a in [3...0]
      for b in [a-1..0]
        if cells[a] is 0 then break
        else if cells[a] == cells[b]
          cells[a] *= 2
          cells[b] = 0
          break
        else if cells[b] isnt 0 then break
    cells

  if direction in ["right", "down"]
    cells = merge(cells)
  else if direction in ["left", "up"]
    cells = merge(cells.reverse()).reverse()

  cells

# console.log "mergeCells #{mergeCells [2,2,0,4], "left"}"
# console.log "mergeCells #{mergeCells [2,2,0,4], "down"}"


moveIsValid = (originalBoard, newBoard) ->
  for row in [0..3]
    for col in [0..3]
      if originalBoard[row][col] isnt newBoard[row][col]
        return true
  false


boardIsFull = (board) ->
  for row in board
    if 0 in row
      return false
  true


noValidMoves = (board) ->
  directions = ["right", "down", "left", "up"]
  for direction in directions
    newBoard = move(board, direction)
    return false if moveIsValid(board, newBoard)
  true


isGameOver = (board) ->
  boardIsFull(board) and noValidMoves(board)


collapseCells = (cells, direction) ->
  #remove 0
  cells = cells.filter (x) -> x isnt 0
  # adding 0
  while cells.length < 4
    if direction in ["right", "down"]
      cells.unshift(0)
    else if direction in ["left", "up"]
      cells.push(0)
  cells
# console.log collapseCells [2,0,2,4], "right"


showBoard = (board) ->
  for row in [0..3]
    for col in [0..3]
      if  board[row][col] == 0
        $(".r#{row}.c#{col} > div").html(" ")
      else
        $(".r#{row}.c#{col} > div").html(board[row][col])
  # console.log "show board"


printArray = (array) ->
  console.log "-- Start --"
  for row in array
    console.log row
  console.log "-- End --"


$ ->
  @board = buildBoard()
  generateTile(@board)
  generateTile(@board)
  printArray(@board)
  showBoard(@board)

  $('body').keydown (e) =>

    key = e.which
    keys = [37, 38, 39, 40, 88, 120]

    if keys.indexOf(key) > -1
      #prevent default key function
      e.preventDefault()

      # console.log "key: #{key}"
      # continue the game
      direction = switch key
        when 37 then "left"
        when 38 then "up"
        when 39 then "right"
        when 40 then "down"
        when 88 then "x"
        when 120 then "x"
      # console.log "direction: #{direction}"

      # try moving
      newBoard = move(@board, direction)
      # printArray(newBoard)

      # check move validity by comparing the original and new board
      if moveIsValid(@board, newBoard)
        # console.log "valid"
        @board = newBoard

        # generate new tile if key isn't "x"
        if direction isnt "x"
          generateTile(@board)

        # check game lost
        if isGameOver(@board)
          console.log "YOU LOSE!"
        else
          #show board
          showBoard(@board)
          # printArray(newBoard)

      else
        console.log "invalid direction"

    else
        #do nothing
