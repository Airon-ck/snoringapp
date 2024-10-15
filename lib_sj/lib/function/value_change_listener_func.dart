

typedef Value2ChangeListener<T,D> = void Function(T value,D value2);

typedef Value2ChangeReturnListener<T,D,R> = R Function(T value,D value2);

typedef Value3ChangeReturnListener<T,D,A,R> = R Function(T value,D value2,A value3);

typedef Value3ChangeListener<T,D,M> = void Function(T value,D value2,M value3);

typedef Value4ChangeListener<T,D,M,N> = void Function(T value,D value2,M value3,N value4);

typedef ValueInitFunc<T> =T Function(dynamic data);