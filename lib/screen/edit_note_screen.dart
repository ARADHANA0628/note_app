import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditNoteScreen extends StatefulWidget {
  final Map<String, String> note;

  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  final List<String> categories = ["Personal", "Work", "Ideas", "Other"];
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    titleController =
        TextEditingController(text: widget.note["title"] ?? "");
    contentController =
        TextEditingController(text: widget.note["content"] ?? "");
    selectedCategory =
        widget.note["category"] ?? categories.first;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    Navigator.pop(context, {
      "title": titleController.text,
      "content": contentController.text,
      "category": selectedCategory,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF5F6FA),

    
      appBar: AppBar(
        title: Text(
          "Edit Note",
          style: GoogleFonts.poppins(
            // fontWeight: FontWeight.w600,
            // color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4D5886), Color(0xFFAC77E2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          
        ),
        
      ),

     
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Title",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
       SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                  )
                ],
              ),
              child: TextField(
                controller: titleController,
                decoration:  InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                ),
              ),
            ),

             SizedBox(height: 20),

            Text(
              "Content",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
             SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow:  [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                  )
                ],
              ),
              child: TextField(
                controller: contentController,
                maxLines: 6,
                decoration:InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                ),
              ),
            ),

             SizedBox(height: 20),

            
            Text(
              "Category",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
             SizedBox(height: 8),
            Container(
              padding:
                   EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow:  [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                  )
                ],
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                underline: SizedBox(),
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat,
                              style:
                                  GoogleFonts.poppins()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ),

             SizedBox(height: 40),
            Center(
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4D5886),
                      Color(0xFFAC77E2)
                    ],
                  ),
                  boxShadow:  [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Save Changes",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}