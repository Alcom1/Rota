boolean debug;        //Debug state.
int gameState;        //Menu or game state.

//transformations
int transStage;       //Transitioning stage.
int transEndState;    //Gamestate that is transitioned into.
float transX;         //Transition x-offset.
float transY;         //Transition y-offset.
float transSpeed;     //Speed of transitions.

//Game grid
Grid grid;            //Grid to play on.

//Buttons
Button buttonPlay;
Button button2Play;
Button buttonSingle;

//Setup
public void setup()
{
    //Canvas parameters
    size(600, 600);
    ellipseMode(CENTER);
    rectMode(CENTER);
    textAlign(CENTER);
    textSize(50);
    
    //Debug
    debug = false;
    
    //Transition;
    transStage = 0;
    transEndState = 0;
    transX = 0;
    transY = 0;
    transSpeed = 40;
    
    //Start at main menu.
    gameState = 0;
    
    //Buttons
    buttonPlay = new ButtonPlay();
    button2Play = new Button2Play();
    buttonSingle = new ButtonSingle();
}

//Drawing
public void draw()
{
    background(#DAE2F3);  //Background
    
    transition();
    
    if(gameState != 1)
    {
        fill(128, 128, 140);
        noStroke();
        rectMode(CORNERS);
        rect(
            0,
            height - 90,
            width,
            height,
            20,
            20,
            20,
            20);
        rectMode(CENTER);
    }
    
    
    pushMatrix();
        translate(transX, transY);
        switch(gameState)
        {
            case 0:
                buttonPlay.check();
                buttonPlay.display();
                break;
            case 1:
                grid.display();            //Display grid
                grid.continueRotate();     //Spin grid (if set to rotate)
                grid.continueWin();
                break;
            case 2:
                buttonSingle.check();
                buttonSingle.display();
                button2Play.check();
                button2Play.display();
                break;
                
        }
    popMatrix();
}

//Mouse pressed
public void mousePressed()
{
    buttonPlay.press();
    button2Play.press();
    buttonSingle.press();
    
    if(gameState == 1 && transStage == 0)
    {
        if(!grid.rotating)
        {
            if(mouseButton == LEFT)
            {
                grid.left = false;
            }
            if(mouseButton == RIGHT)
            {
                grid.left = true;
            }
        }
        grid.place();              //Place grid
    }
}

//Mouse released
public void mouseReleased()
{
    buttonPlay.release();
    button2Play.release();
    buttonSingle.release();
  
    switch(gameState)
    {
        case 0:
            if(buttonPlay.release())
                buttonPlay.action();
            break;
        case 2:
            if(button2Play.release())
                button2Play.action();
            if(buttonSingle.release())
                buttonSingle.action();
            break;
    }
}

//Menu transitions
public void transition()
{
    switch(transStage)
    {
        case 0:
            break;
        case 1:
            transX -= transSpeed * 60 / frameRate;
            if(transX < -width || transY < -height)
            {
                gameState = transEndState;
                transX = width;
                transY = 0;
                transStage = 2;
            }
            break;
        case 2:
            transX -= transSpeed;
            if(transX < 0 || transY < 0)
            {
                transX = 0;
                transY = 0;
                transStage = 0;
            }
            break;
    }
}