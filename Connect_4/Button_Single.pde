//Play button.
public class ButtonSingle extends Button
{
    public ButtonSingle()
    {
        super(
            width / 2,
            height / 2 - 40,
            200,
            60,
            color(220, 220, 220),
            color(102, 102, 102),
            color(190, 190, 190),
            color(102, 102, 102),
            color(220, 180, 040),
            color(102, 102, 102),
            "1 Player",
            40,
            "VS AI Opponent",
            32);
    }
    
    public void action()
    {
        transStage = 1;
        transEndState = 1;
        grid = new Grid(5, 75, true);
        noCursor();
    } 
}