import 'dart:convert';

class NoteModel {
  String title;
  String? description;
  int? id;

  NoteModel({
    required this.title,
    this.description,
    this.id,
  });

  NoteModel copyWith({
    String? title,
    String? description,
    int? id,
  }) {
    return NoteModel(
      title: title ?? this.title,
      description: description ?? this.description,
      id: id ?? this.id
      );
  }
   
   Map<String, dynamic> toMap() {
    return <String, dynamic>{
     'title': title,
     'description': description,
     'id': id,
    };
   }

   factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      title: map['title'] as String,
      description: map['description'] != null ? map['description'] as String : null,
      id: map['id'] != null ? map['id'] as int : null,
      );
   }

   String toJson() => json.encode(toMap());

   factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source)as Map<String, dynamic>);

    @override
    String toString(){
      return 'NoteModel(title: $title, description: $description, id: $id)';
    }   

    @override 
    bool operator ==(covariant NoteModel other) {
      if(identical(this, other)) return true;
      
      return other.title == title && 
            other.description == description &&
            other.id == id;

    }
}