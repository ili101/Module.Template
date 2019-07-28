class Base64Script
{
    [string]$ItemName

    Base64Script([string]$String)
    {
        $this.ItemName = $String
    }

    [string]ToString()
    {
        return $this.ItemName
    }
}