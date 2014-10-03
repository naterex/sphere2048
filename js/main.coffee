buildBoard = ->
  # board = []
  # for row in [0..3]
  #     board[row] = []
  #     console.log "row: ", row

  #     for column in [0..3]
  #         board[row][column] = 0
  #         console.log "column: ", column
  # board[boardArray[0][0],0,0,0]
  [0..3].map -> [0..3].map -> 0


randomInt = (x) ->
  Math.floor(Math.random() * x)


randomCellIndices = ->
  aero = [randomInt(4), randomInt(4)]


randomValue = ->
  values = [2,2,2,4]
  values[randomInt(4)]


generateTile = (board) ->
  value = randomValue()
  [row, column] = randomCellIndices()
  console.log "row: #{row} / col: #{column}"

  if board[row][column] is 0
    board[row][column] = value
  else
    generateTile(board)
    console.log "generate tile"


move = (board, direction) ->
  newBoard = buildBoard()

  for i in [0..3]
    if direction is 'right'
      row = getRow(i, board)
      mergeCells(row, direction)
      row = collapseCells(row, direction)
      setRow(row, i, newBoard)
      # console.log row
  newBoard


getRow = (r, board) ->
  [board[r][0], board[r][1], board[r][2], board[r][3]]


setRow = (row, index, board) ->
  board[index] = row


mergeCells = (row, direction) ->
  if direction is "right"
    for a in [3...0]
      for b in [a-1..0]
        # console.log a, b

        if row[a] is 0 then break
        else if row[a] == row[b]
          row[a] *= 2
          row[b] = 0
        else if row[b] isnt 0 then break
  row
# this row does not merge correct
# console.log mergeCells [2,0,2,2], "right"


moveIsValid = (originalBoard, newBoard) ->
  for row in [0..3]
    for col in [0..3]
      if originalBoard[row][col] isnt newBoard[row][col]
        return true
  false


collapseCells = (row, direction) ->
  #remove 0
  row = row.filter (x) -> x isnt 0
  # adding 0
  while row.length < 4
    row.unshift(0)
  row
# console.log collapseCells [2,0,2,4], "right"


showBoard = (board) ->
  for row in [0..3]
    for col in [0..3]
      $(".r#{row}.c#{col} > div").html(board[row][col])

  console.log "show board"


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
    e.preventDefault()

    key = e.which
    keys = [37..40]

    if keys.indexOf (key) > -1
      console.log "key: #{key}"
      #continue the game
      direction = switch key
        when 37 then 'left'
        when 38 then 'up'
        when 39 then 'right'
        when 40 then 'down'
      console.log "direction: #{direction}"

      #try moving
      newBoard = move(@board, direction)
      printArray(newBoard)

      #check move validity by comparing the original and new board
      if moveIsValid(@board, newBoard)
        console.log "valid"
        @board = newBoard

        #generate board
        generateTile(@board)
        generateTile(@board)

        #show board
        showBoard(@board)

      else
        console.log "invalid"

    else
        #do nothing
