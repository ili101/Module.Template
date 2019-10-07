class PublicClass {
    [string]$ItemName

    PublicClass([string]$String) {
        $this.ItemName = $String
    }

    [string]ToString() {
        return $this.ItemName
    }
}