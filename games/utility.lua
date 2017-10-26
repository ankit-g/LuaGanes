local utility = {}

function utility.getDistance(x1, y1, x2, y2)
        return math.ceil(math.sqrt((x1-x2)^2 + (y1-y2)^2))
end


function utility.get_ball_cordinates(x_res, y_res, radius)
         local diameter = radius*2
         -- no of circles in x axis
         local num_columns = x_res / diameter
         local num_rows = y_res / diameter

         local total_circles = num_rows * num_columns
         local x, y = radius, radius

         local ball_cordinates = {}

          for row = 1, num_rows do
                  ball_cordinates[row] = {}
                  x = radius
                  for column = 1, num_columns do
                          ball_cordinates[row][column] = {}
                          ball_cordinates[row][column].x = x
                          ball_cordinates[row][column].y = y
                          x = x + diameter
                  end
                  y = y + diameter
          end
          return num_rows, num_columns, ball_cordinates
end

return utility
