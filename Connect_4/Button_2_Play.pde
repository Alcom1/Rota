//Play button.
public class Button2Play extends Button
{
    public Button2Play()
    {
        super(
            width / 2,
            height / 2 + 40,
            200,
            60,
            color(220, 220, 220),
            color(102, 102, 102),
            color(190, 190, 190),
            color(102, 102, 102),
            color(220, 180, 040),
            color(102, 102, 102),
            "2 Players",
            40,
            "Two player mode",
            32);
    }
    
    public void action()
    {
        transStage = 1;
        transEndState = 1;
        grid = new Grid(5, 75, false);
        noCursor();
    } 
}