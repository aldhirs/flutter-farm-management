enum DeviceType { mobile, tabletPortrait, tabletLandscape }

enum Flavor { develop, staging, production }

enum SuccessResponseMapperType { dataJsonObject, dataJsonArray }

enum BottomSheetSize { full, half, fitContent }

const DRAFT = 'draft';
const ISSUED = 'issued';
const COMPLETED = 'completed';
const CANCELLED = 'cancelled';
const AVAILABLE = 'available';
const BOOKED = 'booked';

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
  DRAFT: 'Draf',
  ISSUED: 'Sudah Terbit',
  COMPLETED: 'Selesai',
  CANCELLED: 'Dibatalkan',
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

const barnCategoryMap = {
  '': 'Semua',
  "Penggemukan": 'Penggemukan',
  "Karantina": 'Karantina',
  "Isolasi": 'Isolasi',
  "Drafting": 'Drafting',
  "Penjualan": 'Penjualan',
};

const salesItemStatusMap = {AVAILABLE: 'Tersedia', BOOKED: 'Dipesan'};

const genderMap = {"male": 'Jantan', "female": 'Betina'};

const mutationStatusMap = {
  '': 'Semua',
  DRAFT: 'Draf',
  ISSUED: 'Sudah Terbit',
  COMPLETED: 'Selesai',
  CANCELLED: 'Dibatalkan',
};

const mutationItemStatusMap = {
  'available': 'Tersedia',
  'delivered': 'Terkirim',
};
