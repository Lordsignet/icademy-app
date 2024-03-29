void _openDialog() async {
    _selected = await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Full Screen Dialog'),
              actions: [
                new ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop("hai");
                    },
                    child: new Text('ADD',
                        style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Full Screen',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        fullscreenDialog: true
    ));
    if(_selected != null)
    setState(() {
      _selected = _selected;
    });
  }