enum DeviceType { mobile, tabletPortrait, tabletLandscape }

enum Flavor { develop, staging, production }

enum SuccessResponseMapperType { dataJsonObject, dataJsonArray }

enum BottomSheetSize { full, half, fitContent }

const medicalStatusMap = {
  'draft': 'Draf',
  'diagnosed': 'Terdeteksi',
  'in_treatment': 'Sedang Dalam Pemeriksaan',
  'resolved': 'Terselesaikan',
  'unresolved': 'Belum Terselesaikan',
  'cancelled': 'Dibatalkan',
};

const salesStatusMap = {
  '': 'Semua',
  'draft': 'Draf',
  'issued': 'Sudah Terbit',
  'completed': 'Selesai',
  'cancelled': 'Dibatalkan',
};

const cattleStatusMap = {
  'available': 'Tersedia',
  'unavailable': 'Tidak Tersedia',
  'booked': 'Dipesan',
  'sold': 'Terjual',
  'lost': 'Hilang',
  'sick': 'Sakit',
  'mutating': 'Sedang dimutasi',
};

const salesItemStatusMap = {'available': 'Tersedia', 'booked': 'Dipesan'};
