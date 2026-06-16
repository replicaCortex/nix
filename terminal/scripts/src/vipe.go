package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"strings"
)

func main() {
	stat, _ := os.Stdin.Stat()
	if (stat.Mode() & os.ModeCharDevice) != 0 {
		os.Exit(0)
	}

	name := getNameTmpFile()
	defer os.Remove(name)

	editor := os.Getenv("EDITOR")
	if editor == "" {
		log.Panicln("EDITOR DONT SET")
	}

	openFileEditor(name, editor)

	result, err := os.ReadFile(name)
	if err != nil {
		log.Panicln(err)
	}

	fmt.Println(string(strings.TrimSuffix(string(result), "\n")))
}

func getNameTmpFile() string {
	tmp, err := os.CreateTemp("/tmp/", "*")
	if err != nil {
		log.Panicln(err)
	}
	defer tmp.Close()

	io.Copy(tmp, os.Stdin)
	return tmp.Name()
}

func openFileEditor(fileName string, editor string) {
	cmd := exec.Command(editor, fileName)

	tty, err := os.OpenFile("/dev/tty", os.O_RDWR, 0)
	if err != nil {
		log.Panicln(err)
	}
	defer tty.Close()

	cmd.Stdin = tty
	cmd.Stdout = tty
	cmd.Stderr = tty

	err = cmd.Run()
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
