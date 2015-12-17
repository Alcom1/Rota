public class AI
{
    Grid grid;
    ArrayList<int[]> positions;
    
    public AI(Grid _grid)
    {
        grid = _grid;
        positions = new ArrayList<int[]>();
    }
    
    public void place()
    {
        generateMovesList();
        int[] select = positions.get(floor(random(0, positions.size())));
        grid.place(select[0], select[1], getRandomBool());
    }
    
    private void generateMovesList()
    {
        positions = new ArrayList<int[]>();
        int xy = grid.xy;
        for(int j = 0; j < xy; j++)
        {
            for(int i = 0; i < xy; i++)
            {
                if(grid.grid.get(j).get(i).type == 0)
                {
                    positions.add(new int[2]);
                    positions.get(positions.size() - 1)[0] = i;
                    positions.get(positions.size() - 1)[1] = j;
                }
            } 
        }
    }
    
    private boolean getRandomBool()
    {
        if(random(0, 1) < .5f)
            return true;
        return false;
    }
}