class CloudStorageException implements Exception{
  const CloudStorageException();
}

// C
class CouldNotCreateNoteException implements CloudStorageException{}

// R
class CouldNotGetAllNotesException implements CloudStorageException{}

// U
class CouldNotUpdateNoteException implements CloudStorageException{}

// D
class CouldNotDeleteNoteException implements CloudStorageException{}