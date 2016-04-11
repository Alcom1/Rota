//Play button.
public class ButtonPlay extends Button
{
    public ButtonPlay()
    {
        super(
            width / 2,
            height / 2,
            120,
            60,
            color(220, 220, 220),
            color(102, 102, 102),
            color(190, 190, 190),
            color(102, 102, 102),
            color(220, 180, 040),
            color(102, 102, 102),
            "PLAY",
            40,
            "Play the game!",
            32);
    }
    
    public void action()
    {
        transStage = 1;
        transEndState = 2;
    } 
}