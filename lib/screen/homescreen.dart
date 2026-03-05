import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'edit_note_screen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  
  List<Map<String, String>> notes = [];
  List<Map<String, String>> filteredNotes = [];
  
  

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = ["Personal", "Work", "Ideas", "Other"];
  String selectedCategory = "All";

  @override
  @override
void initState() {
  super.initState();



 
 
  filteredNotes = notes;

  searchController.addListener(filterNotes);
}
 filterNotes() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes.where((note) {
        final title = note["title"]?.toLowerCase() ?? "";
        final content = note["content"]?.toLowerCase() ?? "";
        final category = note["category"] ?? "";

        bool matchesQuery = title.contains(query) || content.contains(query);
        bool matchesCategory = selectedCategory == "All" || category == selectedCategory;

        return matchesQuery && matchesCategory;
      }).toList();
    });
  }


   addNote() {
    titleController.clear();
    contentController.clear();
    String tempCategory = categories[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Add Note", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    hintText: "Content",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: tempCategory,
                  items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (value) => setStateDialog(() => tempCategory = value!),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
              ElevatedButton(
                onPressed: () {
  if (titleController.text.isNotEmpty &&
      contentController.text.isNotEmpty) {

    final newNote = {
      "title": titleController.text,
      "content": contentController.text,
      "category": tempCategory,
    };



    setState(() {
      notes.add(newNote);
      filterNotes();
    });

    Navigator.pop(context);
  }
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 227, 228, 231),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Add"),
              ),
            ],
          );
        });
      },
    );
  }


  deleteNote(int index) {
  final originalIndex = notes.indexOf(filteredNotes[index]);

  setState(() {
   
    notes.removeAt(originalIndex);
    filterNotes();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text("My Notes", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4D5886), Color(0xFFAC77E2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(124),
          child: Container(
            padding: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Color(0xFFF5F6FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search notes...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 45,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ["All", ...categories].map((cat) {
                        bool isSelected = selectedCategory == cat;
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              cat,
                              style: GoogleFonts.poppins(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: Color(0xFF4D5886),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = cat;
                                filterNotes();
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(11),
        child: GridView.builder(
          itemCount: filteredNotes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final note = filteredNotes[index];
            return GestureDetector(
              onTap: () async {
                final updatedNote = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditNoteScreen(note: note)),
                );
                if (updatedNote != null) {
                  final originalIndex = notes.indexOf(filteredNotes[index]);
                  setState(() {
                    notes[originalIndex] = updatedNote;
                    filterNotes();
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Color(0xFF4D5886), Color(0xFFAC77E2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            note["title"] ?? "",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => deleteNote(index),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      note["category"] ?? "",
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        note["content"] ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Color(0xFF4D5886), Color(0xFFAC77E2)]),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: addNote,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}