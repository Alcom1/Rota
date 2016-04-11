//Connect 4 grid
public class Grid
{
    //Fields
    ArrayList<ArrayList<GridSpace>> grid;  //2D ArrayList of grid spaces.
    int xy;                                //width and height of the grid.
    int spaceSize;                         //width and height of each grid space.
    float rotation;                        //Current rotation of the grid.
    float rotationSpeed;                   //Speed of rotation.
    boolean rotating;                      //True if the grid is rotating.
    boolean left;                          //True if rotating left.    
    int orientation;                       //Integer orientation of the grid.
    
    int victoryType;                       //Type of the winner.
    ArrayList<int[]> victoryLine;          //Integer indexes of the victory lines.
    int victoryStage;                      //Integer stage of victory.
    float victoryRotationAccPushA;
    float victoryRotationAccPullA;
    float victoryRotationAccPullB;
    float victoryRotationSpeed;
    boolean victory;                       //True while a victory is in progress.
    
    float cursorX;                         //Relative X Position of the cursor.
    float cursorY;                         //Relative Y Position of the cursor.
    int cursorIndexX;                      //Relative X Index of the cursor.
    int cursorIndexY;                      //Relative Y Index of the cursor.
    int type;                              //Type of the cursor.
    
    AI ai;                                 //game AI;
    boolean aiUse;                         //true if vs AI;
    
    //Constructor
    public Grid(int _xy, int _spaceSize, boolean _aiUse)
    {
        //From parameters
        xy = _xy;
        spaceSize = _spaceSize;
        
        //Instantiate grid
        setGrid();
        
        //Start at 0
        cursorX = 0;
        cursorY = 0;
        cursorIndexX = 0;
        cursorIndexY = 0;
        
        //Start at false;
        rotating = false;
        left = true;
        
        //Victory values, resets are in setGrid()
        victoryRotationAccPushA = .005;
        victoryRotationAccPullA = .02;
        victoryRotationAccPullB = .15;
        
        //Rotation speed;
        rotationSpeed = 1;
        
        //AI
        ai = new AI(this);
        aiUse = _aiUse;
    }
    
    
    //Instantiates or Re-instantiates the grid.
    private void setGrid()
    {
        //Instantiate the grid with xy dimensions.
        grid = new ArrayList<ArrayList<GridSpace>>();
        for(int j = 0; j < xy; j++)
        {
            grid.add(new ArrayList<GridSpace>());
            for(int i = 0; i < xy; i++)
            {
                grid.get(j).add(new GridSpace());
            }
        }
      
        //Resets rotation and orientation
        rotation = 0;
        orientation = 0;
        
        //Resets victory conditions
        victoryLine = new ArrayList<int[]>();
        for(int i = 0; i < 2; i++)
        {
            victoryLine.add(new int[4]); 
        }
        victoryStage = 0;
        victoryRotationSpeed = 0;
        victory = false;
        victoryType = 0;
        
        //Black goes first
        type = 2;
    }
    
    //Display grid
    public void display()
    {
        //Offset to center and by rotation.
        pushMatrix();
            //offset
            translate(width / 2, height / 2);
            rotate(radians(rotation));
            
            //Draw grid squares
            for(int j = 0; j < xy; j++)
            {
                for(int i = 0; i < xy; i++)
                {
                    grid.get(j).get(i).displayBack(i, j, xy, spaceSize);
                }
            }
            
            //Draw grid pieces
            for(int j = 0; j < xy; j++)
            {
                for(int i = 0; i < xy; i++)
                {
                    grid.get(j).get(i).displayPiece(i, j, xy, spaceSize);
                }
            }
            
            //Debug icons
            if(debug)
            {
                fill(255, 0, 0);
                pushMatrix();
                    translate(0, xy * spaceSize / 2 + spaceSize / 2);
                    rotate(0);
                    text("0", 0, 0);
                popMatrix();
                pushMatrix();
                    translate(xy * spaceSize / 2 + spaceSize / 2, 0);
                    rotate(radians(-90));
                    text("1", 0, 0);
                popMatrix();
                pushMatrix();
                    translate(0, -xy * spaceSize / 2 - spaceSize / 2);
                    rotate(radians(-180));
                    text("2", 0, 0);
                popMatrix();
                pushMatrix();
                    translate(-xy * spaceSize / 2 - spaceSize / 2, 0);
                    rotate(radians(-270));
                    text("3", 0, 0);
                popMatrix();
            }
            
            //Calculate cursor relative and relative index positions.
            cursorX = (mouseY - height / 2) * sin(radians(rotation)) + (mouseX - width / 2) * cos(radians(rotation));
            cursorY = (mouseY - height / 2) * cos(radians(rotation)) - (mouseX - width / 2) * sin(radians(rotation));
            cursorIndexX = round((xy * spaceSize / 2 + cursorX) / spaceSize);
            cursorIndexY = round((xy * spaceSize / 2 + cursorY) / spaceSize);
                
            //Snap cursor to nearest grid space
            if(
              cursorX > - xy * spaceSize / 2 &&
              cursorX < xy * spaceSize / 2 &&
              cursorY > - xy * spaceSize / 2 &&
              cursorY < xy * spaceSize / 2)
            {
                cursorX = cursorIndexX * spaceSize - (xy - 1) * spaceSize / 2;
                cursorY = cursorIndexY * spaceSize - (xy - 1) * spaceSize / 2;
            }
            
            //Draw victory line
            if(victory)
            {
                textSize(64);
                int victoryColor = 0;
                String victoryText = "";
                switch(victoryType)
                {
                    case 1:
                        victoryColor = color(255, 0, 0);
                        victoryText = "Red Wins!";
                        break;
                    case 2:
                        victoryColor = color(32, 32, 32);
                        victoryText = "Black Wins!";
                        break;
                    case 3:
                        victoryColor = color(128, 128, 150);
                        victoryText = "TIE";
                        break;
                }
                
                //Don't draw a victory line if there is a tie.
                if(victoryType != 3)
                {
                    //Victory Line
                    strokeWeight(spaceSize * .52f);
                    stroke(0);
                    line(
                        victoryLine.get(victoryType - 1)[0] * spaceSize - (xy - 1) * spaceSize / 2,
                        victoryLine.get(victoryType - 1)[1] * spaceSize - (xy - 1) * spaceSize / 2,
                        victoryLine.get(victoryType - 1)[2] * spaceSize - (xy - 1) * spaceSize / 2,
                        victoryLine.get(victoryType - 1)[3] * spaceSize - (xy - 1) * spaceSize / 2);
                        strokeWeight(spaceSize * .5f);
                    stroke(victoryColor);
                    line(
                        victoryLine.get(victoryType - 1)[0] * spaceSize - (xy - 1) * spaceSize / 2,
                        victoryLine.get(victoryType - 1)[1] * spaceSize - (xy - 1) * spaceSize / 2,
                        victoryLine.get(victoryType - 1)[2] * spaceSize - (xy - 1) * spaceSize / 2,
                        victoryLine.get(victoryType - 1)[3] * spaceSize - (xy - 1) * spaceSize / 2);
                }
                
                //Victory text
                rotate(-radians(rotation));
                //Text background outline
                stroke(0);
                strokeWeight(84);
                line(
                   -width / 2 + 50,
                    height / 2 - 50,
                    width / 2 - 50,
                    height / 2 - 50);
                //Text background
                stroke(255);
                strokeWeight(80);
                line(
                   -width / 2 + 50,
                    height / 2 - 50,
                    width / 2 - 50,
                    height / 2 - 50);
                //Text
                fill(victoryColor);
                text(
                    victoryText,
                    0,
                    height / 2 - 50 + textAscent() / 4 + textDescent() / 2);
                rotate(radians(rotation));
            }
            
            //Draw cursor
            switch(type)
            {
                //Red cursor
                case 1:
                    fill(255, 0, 0);
                    stroke(255);
                    strokeWeight(3);
                    break;
                    
                //Black cursor
                case 2:
                    fill(32, 32, 32);
                    stroke(255);
                    strokeWeight(3);
                    break;
            }
            
            //Cursor shape
            ellipse(
                cursorX,
                cursorY,
                spaceSize * .4,
                spaceSize * .4);    
        popMatrix();
    }
    
    //Initiate rotation
    private void triggerRotate()
    {
        //Set orientation left or right depending on left boolean.
        if(left)
        {
            incrementOrientation();  //Increase orientation if turning left.
        }
        else
        {
            decrementOrientation();  //Decrease orientation if turning right.
        }
        
        //Start rotating.
        rotating = true;
        
        //Sets all pieces for falling.
        //1. Goes through all grid spaces from oriented bottom to oriented top.
        //2. Any occupied grid space is swapped with the bottom-most unoccupied grid space.
        //3. The piece in the now occupied grid space is offset so it still appears in its original location.
        //4. The piece is set to fall, and will fall to its actual position.
        switch(orientation)
        {
            case 0:
                for(int j = xy - 1; j >= 0; j--)                                          //Step 1 go through bottom to top
                {
                    for(int i = 0; i < xy; i++)                                           //Step 1 go through sideways
                    {
                        if(grid.get(j).get(i).type > 0)                                   //Step 2 check for occupation
                        {
                            for(int k = xy - 1; k > j; k--)                               //Step 2 search for unoccupied
                            {
                                if(grid.get(k).get(i).type == 0)                          //Step 2 if unoccupied
                                {
                                    grid.get(k).get(i).type = grid.get(j).get(i).type;    //Step 2 swap part I
                                    grid.get(j).get(i).type = 0;                          //Step 2 swap part II
                                    grid.get(k).get(i).offY = (j - k) * spaceSize;        //Step 3 offset
                                    break;
                                }
                            }
                        }
                    }
                }
                break;
            case 1:
                for(int j = 0; j < xy; j++)                                               //Step 1 go through bottom to top
                {
                    for(int i = xy - 1; i >= 0; i--)                                      //Step 1 go through sideways
                    {
                        if(grid.get(j).get(i).type > 0)                                   //Step 2 check for occupation
                        {
                            for(int k = xy - 1; k >= i; k--)                              //Step 2 search for unoccupied
                            {
                                if(grid.get(j).get(k).type == 0)                          //Step 2 if unoccupied
                                {
                                    grid.get(j).get(k).type = grid.get(j).get(i).type;    //Step 2 swap part I
                                    grid.get(j).get(i).type = 0;                          //Step 2 swap part II
                                    grid.get(j).get(k).offX = (i - k) * spaceSize;        //Step 3 offset
                                    break;
                                }
                            }
                        }
                    }
                }
                break;
            case 2:
                for(int j = 0; j < xy; j++)                                               //Step 1 go through bottom to top
                {
                    for(int i = 0; i < xy; i++)                                           //Step 1 go through sideways
                    {
                        if(grid.get(j).get(i).type > 0)                                   //Step 2 check for occupation
                        {
                            for(int k = 0; k <= j; k++)                                   //Step 2 search for unoccupied
                            {
                                if(grid.get(k).get(i).type == 0)                          //Step 2 if unoccupied
                                {
                                    grid.get(k).get(i).type = grid.get(j).get(i).type;    //Step 2 swap part I
                                    grid.get(j).get(i).type = 0;                          //Step 2 swap part II
                                    grid.get(k).get(i).offY = (j - k) * spaceSize;        //Step 3 offset
                                    break;
                                }
                            }
                        }
                    }
                }
                break;
            case 3:
                for(int j = 0; j < xy; j++)                                               //Step 1 go through bottom to top
                {
                    for(int i = 0; i < xy; i++)                                           //Step 1 go through sideways
                    {
                        if(grid.get(j).get(i).type > 0)                                   //Step 2 check for occupation
                        {
                            for(int k = 0; k <= i; k++)                                   //Step 2 search for unoccupied
                            {
                                if(grid.get(j).get(k).type == 0)                          //Step 2 if unoccupied
                                {
                                    grid.get(j).get(k).type = grid.get(j).get(i).type;    //Step 2 swap part I
                                    grid.get(j).get(i).type = 0;                          //Step 2 swap part II
                                    grid.get(j).get(k).offX = (i - k) * spaceSize;        //Step 3 offset
                                    break;
                                }
                            }
                        }
                    }
                }
                break;         
        }
        
        //Initiate falling for all grid spaces.
        for(int j = 0; j < xy; j++)
        {
            for(int i = 0; i < xy; i++)
            {
                grid.get(j).get(i).triggerFall(rotation);  //Step 4 initiate falling
            }
        }  
    }
    
    //Increment orientation.
    private void incrementOrientation()
    {
        orientation++;
        if(orientation > 3)  //Loop orientation between 0 and 3
            orientation = 0;
    }
    
    //Decrement orientation.
    private void decrementOrientation()
    {
        orientation--;
        if(orientation < 0)  //Loop orientation between 0 and 3
            orientation = 3;
    }
    
    //Rotate.
    public void continueRotate()
    {
        //Only rotate if rotation has been initiated
        if(rotating)
        {
            if(left)
            {
                rotation += rotationSpeed * 60 / frameRate;  //Increment rotation to rotate.
            }
            else
            {
                rotation -= rotationSpeed * 60 / frameRate;  //Decrement rotation to rotate.
            }
            
            //Check if right angle rotation was performed and stop. Also check for win.
            if(abs(rotation) > 90)
            {
                endRotation(true);
                switch(checkWin())      //If win, proceed with victory sequence.
                {
                    case 0:
                        if(aiUse && type == 1)
                        {
                            ai.place();
                        }
                        break;
                    case 1:
                        triggerWin();
                        victoryType = 1;
                        type = 1;
                        break;
                    case 2:
                        triggerWin();
                        victoryType = 2;
                        type = 2;
                        break;
                    case 3:
                        triggerWin();
                        type = type == 1 ? 2 : 1;  //Swap cursor type.
                        victoryType = type;
                        break;
                    case 4:
                        triggerWin();
                        victoryType = 3;
                        break;
                }
            }
        }
        
        //All pieces fall while and after rotation proceeds.
        for(int j = 0; j < xy; j++)
        {
            for(int i = 0; i < xy; i++)
            {
                grid.get(j).get(i).continueFall(rotation, left, orientation);
            }
        }  
    }
    
    //Ends the rotation. If center is true, resets the board so that the orientation is 0.
    private void endRotation(boolean center)
    {
        rotating = false;  //Stop rotating.
        
        //If center
        if(center)
        {
            rotation = 0;                                                                  //rotation returns to 0.
            ArrayList<ArrayList<GridSpace>> temp = new ArrayList<ArrayList<GridSpace>>();  //Create new temporary grid.

            //Fill temp to match grid.
            switch(orientation)
            {
                case 1:
                    for(int j = 0; j < xy; j++)
                    {
                        temp.add(new ArrayList<GridSpace>());
                        for(int i = 0; i < xy; i++)
                        {
                            temp.get(j).add(grid.get(xy - i - 1).get(j));
                        }
                    }
                    break;
                case 3:
                    for(int j = 0; j < xy; j++)
                    {
                        temp.add(new ArrayList<GridSpace>());
                        for(int i = 0; i < xy; i++)
                        {
                            temp.get(j).add(grid.get(i).get(xy - j - 1));
                        }
                    }
                    break; 
            }
            grid = temp;      //temp is now new grid.
            orientation = 0;  //Orientation is back to 0.
        }
        //If not center, set rotation to be a perfect right angle by flooring the rotation.
        else
        {
            rotation = floor(rotation);
        }
    }
    
    //Initiate victory sequence.
    private void triggerWin()
    {
        victory = true;
        rotation = 0;
    }
    
    //Win.
    public void continueWin()
    {
        if(victory && victoryType != 3)
        {
            if(!mousePressed)
            {
                switch(victoryStage)
                {
                    case 0:
                        victoryRotationSpeed += victoryRotationAccPushA * 60 / frameRate;
                        break;
                    case 1:
                        victoryRotationSpeed -= victoryRotationAccPullA * 60 / frameRate;
                        break;
                    case 2:
                        victoryRotationSpeed -= victoryRotationAccPullB * 60 / frameRate; 
                }
                
                rotation += victoryRotationSpeed * 60 / frameRate;
            }
            
            if(rotation > 20)
                victoryStage = 1;
            if(victoryStage == 1 && rotation < -45)
                victoryStage = 2;
            if(rotation < -1620)
            {
                setGrid();        //Reset grid.
            }
        }
        else if(victory)
        {
            if(!mousePressed)
            {
                rotation += rotationSpeed * 60 / frameRate;
                victoryRotationSpeed += 1 * 60 / frameRate;
            }
            if(victoryRotationSpeed > 300)
            {
                setGrid();
            }
        }
    }
    
    //Place piece based on cursor index.
    public void place()
    {
        if(
              !rotating &&                                          //If not rotating
              !victory &&                                           //and if not in victory
              cursorX > - xy * spaceSize / 2 &&                     //and if within the grid
              cursorX < xy * spaceSize / 2 &&
              cursorY > - xy * spaceSize / 2 &&
              cursorY < xy * spaceSize / 2 &&
              grid.get(cursorIndexY).get(cursorIndexX).type == 0)   //and if grid space is unoccupied.
        {
            grid.get(cursorIndexY).get(cursorIndexX).type = type;   //Place piece.
            type = type == 1 ? 2 : 1;                               //Swap cursor type.
            triggerRotate();                                        //Start rotation.
        } 
    }
    
    //Place piece based on given parameters
    public void place(int indexX, int indexY, boolean tempLeft)
    {
        if(
            !rotating &&                                          //If not rotating
            !victory)                                             //and if not in victory
        {
            left = tempLeft;
            grid.get(indexY).get(indexX).type = type;
            type = type == 1 ? 2 : 1;
            triggerRotate();
        }
    }
    
    //Check if 4-in-a-row has occured.
    private int checkWin()
    {
        //Check if the grid is full.
        boolean full = true;
        for(int j = 0; j < xy; j++)
        {
            for(int i = 0; i < xy; i++)
            {
                if(grid.get(j).get(i).type == 0)
                {
                    full = false;
                    break;
                }
            }
            if(!full)
                break;
        }
        if(full)
        {
            return 4;
        }
        
        int temp0 = 0;
        int temp1 = 0;
        int temp2 = 0;
        
        //Check all grid spaces.
        for(int j = 0; j < xy; j++)
        {
            for(int i = 0; i < xy; i++)
            {
                //Get the type of piece in the grid space.
                int tempType = 0;                        //Type of piece in the grid.
                if(grid.get(j).get(i).type == 1)         //If piece is red.
                {
                    tempType = 1; 
                }
                else if(grid.get(j).get(i).type == 2)    //If piece is black.
                {
                    tempType = 2; 
                }
                
                //If there is a piece.
                if(tempType != 0)
                {
                    //For all four directions of connect-4 (two straight, two diagonal)
                    for(int k = 0; k < 4; k++)
                    {
                        //Checks a direction for a connect-4
                        //1. Loop in direction and check grid spaces in that direction.
                        //2. If a grid space doesn't match, break.
                        //3. If all grid spaces match, set the cooresponding integer.
                        //4. Catch all out of bounds exceptions and do nothing.
                        switch(k)
                        {
                            //Horizontal check.
                            case 0:
                                try                                                        //Try-Catch as some comparisons go off the grid.
                                {
                                    for(int l = 1; l < 4; l++)                             //Step 1 loop from 1 to 3
                                    {
                                        if(!(grid.get(j).get(i + l).type == tempType))     //Step 1 check
                                        {
                                           break;                                          //Step 2 break
                                        }
                                        if(l == 3)                                         //Step 3 if all grid spaces match
                                        {
                                            victoryLine.get(tempType - 1)[0] = i;
                                            victoryLine.get(tempType - 1)[1] = j;
                                            victoryLine.get(tempType - 1)[2] = i + l;
                                            victoryLine.get(tempType - 1)[3] = j;
                                            if(tempType == 1)                              //Step 3 set integer.
                                                temp1 = 1;
                                            else
                                                temp2 = 2;
                                        }
                                    }
                                }
                                catch(IndexOutOfBoundsException e)                         //Step 4 catch
                                {
                                  
                                }
                                break;
                            
                            //Positive Diagonal check.
                            case 1:
                                try                                                        //Try-Catch as some comparisons go off the grid.
                                {
                                    for(int l = 1; l < 4; l++)                             //Step 1 loop from 1 to 3
                                    {
                                        if(!(grid.get(j + l).get(i + l).type == tempType)) //Step 1 check
                                        {
                                           break;                                          //Step 2 break
                                        }
                                        if(l == 3)                                         //Step 3 if all grid spaces match
                                        {
                                            victoryLine.get(tempType - 1)[0] = i;
                                            victoryLine.get(tempType - 1)[1] = j;
                                            victoryLine.get(tempType - 1)[2] = i + l;
                                            victoryLine.get(tempType - 1)[3] = j + l;
                                            if(tempType == 1)                              //Step 3 set integer.
                                                temp1 = 1;
                                            else
                                                temp2 = 2;
                                        }
                                    }
                                }
                                catch(IndexOutOfBoundsException e)                         //Step 4 catch
                                {
                                  
                                }
                                break;
                            
                            //Vertical check.
                            case 2:
                                try                                                        //Try-Catch as some comparisons go off the grid.
                                {
                                    for(int l = 1; l < 4; l++)                             //Step 1 loop from 1 to 3
                                    {
                                        if(!(grid.get(j + l).get(i).type == tempType))     //Step 1 check
                                        {
                                           break;                                          //Step 2 break
                                        }
                                        if(l == 3)                                         //Step 3 if all grid spaces match
                                        {
                                            victoryLine.get(tempType - 1)[0] = i;
                                            victoryLine.get(tempType - 1)[1] = j;
                                            victoryLine.get(tempType - 1)[2] = i;
                                            victoryLine.get(tempType - 1)[3] = j + l;
                                            if(tempType == 1)                              //Step 3 set integer.
                                                temp1 = 1;
                                            else
                                                temp2 = 2;
                                        }
                                    }
                                }
                                catch(IndexOutOfBoundsException e)                         //Step 4 catch
                                {
                                  
                                }
                                break;
                            
                            //Negative diagonal check.
                            case 3:
                                try                                                        //Try-Catch as some comparisons go off the grid.
                                {
                                    for(int l = 1; l < 4; l++)                             //Step 1 loop from 1 to 3
                                    {
                                        if(!(grid.get(j + l).get(i - l).type == tempType)) //Step 1 check
                                        {
                                           break;                                          //Step 2 break
                                        }
                                        if(l == 3)                                         //Step 3 if all grid spaces match
                                        {
                                            victoryLine.get(tempType - 1)[0] = i;
                                            victoryLine.get(tempType - 1)[1] = j;
                                            victoryLine.get(tempType - 1)[2] = i - l;
                                            victoryLine.get(tempType - 1)[3] = j + l;
                                            if(tempType == 1)                              //Step 3 set integer.
                                                temp1 = 1;
                                            else
                                                temp2 = 2;
                                        }
                                    }
                                }
                                catch(IndexOutOfBoundsException e)                         //Step 4 catch
                                {
                                  
                                }
                                break;
                        } 
                    }
                }
            }
        }
    
        return temp0 + temp1 + temp2;  //Return 0 if all comparisons failed.
    }
}