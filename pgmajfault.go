package main
import (
    "golang.org/x/exp/mmap"
    "fmt"
    "os"
)

func main() {
    args := os.Args[1:]
    if len(args) == 0 {
        fmt.Println("Please specify a file path")
        os.Exit(1)
    }

    m, err := mmap.Open(args[0])
    if err != nil {
        fmt.Println("File does not exist!")
        os.Exit(1)
    }

    for i:=0; i<m.Len(); i++ {
        _ = m.At(i)
    }
    fmt.Printf("I've read %d bytes.\n", m.Len())
}
