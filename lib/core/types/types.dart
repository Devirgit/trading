typedef StockUid = int;
typedef CategoryUID = int;
typedef DealUid = int;

enum DealType { sell, buy }

enum LoadDataStatus { none, empty, loading, changed, failure, success }
