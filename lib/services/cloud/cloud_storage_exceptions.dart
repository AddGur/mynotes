class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotCreateNoteException extends CloudStorageExceptions {}

class CouldNotGetAllNotesException extends CloudStorageExceptions {}

class CouldNortUpdateNoteException extends CloudStorageExceptions {}

class CouldNotDeleteNoteExceptions extends CloudStorageExceptions {}
