import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ritoku_app/functions/sign_in.dart';

var documentReference;
var countHours = 0;
var countMinutes = 0;
var countRank = 0;
var countStreak = 0;
var notesCount = 1;

class Note {
  String noteDesc;
  String noteName;
  int noteHours;
  int noteMinutes;

  Note(String noteDesc, String noteName, int noteHours, int noteMinutes,){
    this.noteDesc = noteDesc; 
    this.noteName = noteName; 
    this.noteHours = noteHours; 
    this.noteMinutes = noteMinutes;
  }
}

List<Note> notes = [
  Note('Time to Sync!', 'Double Tap to Sync your notes.', 12, 34),
];


void setDoc() {
  documentReference = Firestore.instance.document("users/$email");
}
void fetch() {
  documentReference.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      countHours = datasnapshot.data['hours'];
      countMinutes = datasnapshot.data['minutes'];
      countRank = datasnapshot.data['rank'];
      countStreak = datasnapshot.data['streak'];
      notesCount = datasnapshot.data['notecount'];
      fetchNotes();
    }
  });
}


void fetchNotes() {
  var noteName, noteHours, noteMinutes, noteDesc;
  if(notesCount == 0){
    notes.clear();
    notesCount = 1;
    print('nothin');
    notes.add(new Note("You currently have nothing recorded", "Add a note!", 12, 34));
    return;
  }
  if(notes[0].noteName.compareTo("Double Tap to Sync your notes.") == 0 || notes[0].noteName.compareTo("Add a note!") == 0) notes.clear();
      
  for(int index = notes.length; index < notesCount; index++){
    var documentReferences =
        Firestore.instance.collection("users").document("$email").collection("notes").document("$index");
  documentReferences.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        noteName = datasnapshot.data['name'];
        noteHours = datasnapshot.data['hours'];
        noteMinutes = datasnapshot.data['minutes'];
        noteDesc = datasnapshot.data['desc'];
        notes.add(new Note(noteDesc, noteName, noteHours, noteMinutes));
      }

    });
  }
}