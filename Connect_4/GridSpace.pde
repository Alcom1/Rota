//Connect 4 grid space
public class GridSpace
{
    //fields
    int type;            //Type of grid space. 0 = empty, 1 = red, 2 = black
    float offX;          //X offset of the piece
    float offY;          //Y offset of the piece
    float speed;         //Speed of the piece
    float gravity;       //Gravity acceleration acting on the piece
    float initialAngle;  //Initial angle of the board when falling begins.
    boolean falling;     //True for while piece is falling.
    boolean positive;    //True if falling direction is positive.
    
    //Constructor
    public GridSpace()
    {
        //Most stuff starts at 0 or false.
        type = 0;
        offX = 0;
        offY = 0;
        speed = 0;
        gravity = .6;      //Fixed gravity acceleration does not start at 0.
        initialAngle = 0;
        falling = false;
        positive = false;
    }
    
    //Display the back based on parameters from the containing 2D Arraylist.
    public void displayBack(int i, int j, int xy, int spaceSize)
    {
        fill(255);
        stroke(0);
        strokeWeight(3);
        rect(
            i * spaceSize - (xy - 1) * spaceSize / 2,
            j * spaceSize - (xy - 1) * spaceSize / 2,
            spaceSize,
            spaceSize);      
    }
    
    //display the piece based on parameters from the containing 2D Arraylist.
    public void displayPiece(int i, int j, int xy, int spaceSize)
    {
        switch(type)
        {
            //Display a red piece.
            case 1:
                fill(255, 0, 0);
                stroke(0);
                strokeWeight(1);
                ellipse(
                    i * spaceSize - (xy - 1) * spaceSize / 2 + offX,
                    j * spaceSize - (xy - 1) * spaceSize / 2 + offY,
                    spaceSize * .8,
                    spaceSize * .8);                
                break;
                
            //Display a black piece.
            case 2:
                fill(32, 32, 32);
                stroke(0);
                strokeWeight(1);
                ellipse(
                    i * spaceSize - (xy - 1) * spaceSize / 2 + offX,
                    j * spaceSize - (xy - 1) * spaceSize / 2 + offY,
                    spaceSize * .8,
                    spaceSize * .8);     
                break; 
        }      
    }
    
    //Initiate falling.
    public void triggerFall(float rotation)
    {
        if(offX != 0 || offY != 0)  //If there is an offset, start falling.
        {
            falling = true;
        }
        
        //Get initial angle to measure rotation from.
        initialAngle = rotation;
    }
    
    //Continue falling.
    public void continueFall(float rotation, boolean left, int orientation)
    {
        //Fall if falling
        if(falling)
        {
            //Fall backwards if turning left.
            if(left)
            {
                speed -= gravity * sin(radians(initialAngle - rotation)) * 60 / frameRate;
            }
            
            //Fall forwards if turning right.
            else
            {
                speed += gravity * sin(radians(initialAngle - rotation)) * 60 / frameRate;
            }
            
            //Contiues the falling of the pieces.
            //1. Increments or Decrements the offset.
            //2. If the offset passes 0, the piece settles.
            switch(orientation)
            {
                case 0:
                    offY += speed * 60 / frameRate;  //Step 1 increment y offset
                  
                    if(offY > 0)                     //Step 2 check if offset passed 0.
                    {
                        settle();                    //Step 2 settle
                    }
                    break;
                case 1:
                    offX += speed * 60 / frameRate;  //Step 1 increment x offset
                  
                    if(offX > 0)                     //Step 2 check if offset passed 0.
                    {
                        settle();                    //Step 2 settle
                    }
                    break;
                case 2:
                    offY -= speed * 60 / frameRate;  //Step 1 decrement y offset 
                  
                    if(offY < 0)                     //Step 2 check if offset passed 0.
                    {
                        settle();                    //Step 2 settle
                    }
                    break;
                case 3:
                    offX -= speed * 60 / frameRate;  //Step 1 decrement x offset 
                  
                    if(offX < 0)                     //Step 2 check if offset passed 0.
                    {
                        settle();                    //Step 2 settle
                    }
                    break;
            }
        }
    }
    
    //Stops falling and resets related values.
    private void settle()
    {
        offX = 0;
        offY = 0;
        speed = 0;
        initialAngle = 0;
        falling = false;
        positive = false;  
    }
}