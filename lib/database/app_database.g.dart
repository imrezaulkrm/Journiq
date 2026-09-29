// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $JourneysTable extends Journeys with TableInfo<$JourneysTable, Journey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JourneysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<int> mode = GeneratedColumn<int>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeDurationSecondsMeta =
      const VerificationMeta('activeDurationSeconds');
  @override
  late final GeneratedColumn<int> activeDurationSeconds = GeneratedColumn<int>(
    'active_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _averageSpeedKmhMeta = const VerificationMeta(
    'averageSpeedKmh',
  );
  @override
  late final GeneratedColumn<double> averageSpeedKmh = GeneratedColumn<double>(
    'average_speed_kmh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxSpeedKmhMeta = const VerificationMeta(
    'maxSpeedKmh',
  );
  @override
  late final GeneratedColumn<double> maxSpeedKmh = GeneratedColumn<double>(
    'max_speed_kmh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startLatitudeMeta = const VerificationMeta(
    'startLatitude',
  );
  @override
  late final GeneratedColumn<double> startLatitude = GeneratedColumn<double>(
    'start_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startLongitudeMeta = const VerificationMeta(
    'startLongitude',
  );
  @override
  late final GeneratedColumn<double> startLongitude = GeneratedColumn<double>(
    'start_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endLatitudeMeta = const VerificationMeta(
    'endLatitude',
  );
  @override
  late final GeneratedColumn<double> endLatitude = GeneratedColumn<double>(
    'end_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endLongitudeMeta = const VerificationMeta(
    'endLongitude',
  );
  @override
  late final GeneratedColumn<double> endLongitude = GeneratedColumn<double>(
    'end_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherTemperatureMeta =
      const VerificationMeta('weatherTemperature');
  @override
  late final GeneratedColumn<double> weatherTemperature =
      GeneratedColumn<double>(
        'weather_temperature',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _weatherConditionMeta = const VerificationMeta(
    'weatherCondition',
  );
  @override
  late final GeneratedColumn<String> weatherCondition = GeneratedColumn<String>(
    'weather_condition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherHumidityMeta = const VerificationMeta(
    'weatherHumidity',
  );
  @override
  late final GeneratedColumn<int> weatherHumidity = GeneratedColumn<int>(
    'weather_humidity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherWindSpeedMeta = const VerificationMeta(
    'weatherWindSpeed',
  );
  @override
  late final GeneratedColumn<double> weatherWindSpeed = GeneratedColumn<double>(
    'weather_wind_speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherRainProbabilityMeta =
      const VerificationMeta('weatherRainProbability');
  @override
  late final GeneratedColumn<int> weatherRainProbability = GeneratedColumn<int>(
    'weather_rain_probability',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherObservedAtMeta = const VerificationMeta(
    'weatherObservedAt',
  );
  @override
  late final GeneratedColumn<DateTime> weatherObservedAt =
      GeneratedColumn<DateTime>(
        'weather_observed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _areasCoveredMeta = const VerificationMeta(
    'areasCovered',
  );
  @override
  late final GeneratedColumn<String> areasCovered = GeneratedColumn<String>(
    'areas_covered',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    startTime,
    endTime,
    activeDurationSeconds,
    distanceMeters,
    averageSpeedKmh,
    maxSpeedKmh,
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
    weatherTemperature,
    weatherCondition,
    weatherHumidity,
    weatherWindSpeed,
    weatherRainProbability,
    weatherObservedAt,
    areasCovered,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journeys';
  @override
  VerificationContext validateIntegrity(
    Insertable<Journey> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('active_duration_seconds')) {
      context.handle(
        _activeDurationSecondsMeta,
        activeDurationSeconds.isAcceptableOrUnknown(
          data['active_duration_seconds']!,
          _activeDurationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeDurationSecondsMeta);
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanceMetersMeta);
    }
    if (data.containsKey('average_speed_kmh')) {
      context.handle(
        _averageSpeedKmhMeta,
        averageSpeedKmh.isAcceptableOrUnknown(
          data['average_speed_kmh']!,
          _averageSpeedKmhMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_averageSpeedKmhMeta);
    }
    if (data.containsKey('max_speed_kmh')) {
      context.handle(
        _maxSpeedKmhMeta,
        maxSpeedKmh.isAcceptableOrUnknown(
          data['max_speed_kmh']!,
          _maxSpeedKmhMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxSpeedKmhMeta);
    }
    if (data.containsKey('start_latitude')) {
      context.handle(
        _startLatitudeMeta,
        startLatitude.isAcceptableOrUnknown(
          data['start_latitude']!,
          _startLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('start_longitude')) {
      context.handle(
        _startLongitudeMeta,
        startLongitude.isAcceptableOrUnknown(
          data['start_longitude']!,
          _startLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('end_latitude')) {
      context.handle(
        _endLatitudeMeta,
        endLatitude.isAcceptableOrUnknown(
          data['end_latitude']!,
          _endLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('end_longitude')) {
      context.handle(
        _endLongitudeMeta,
        endLongitude.isAcceptableOrUnknown(
          data['end_longitude']!,
          _endLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('weather_temperature')) {
      context.handle(
        _weatherTemperatureMeta,
        weatherTemperature.isAcceptableOrUnknown(
          data['weather_temperature']!,
          _weatherTemperatureMeta,
        ),
      );
    }
    if (data.containsKey('weather_condition')) {
      context.handle(
        _weatherConditionMeta,
        weatherCondition.isAcceptableOrUnknown(
          data['weather_condition']!,
          _weatherConditionMeta,
        ),
      );
    }
    if (data.containsKey('weather_humidity')) {
      context.handle(
        _weatherHumidityMeta,
        weatherHumidity.isAcceptableOrUnknown(
          data['weather_humidity']!,
          _weatherHumidityMeta,
        ),
      );
    }
    if (data.containsKey('weather_wind_speed')) {
      context.handle(
        _weatherWindSpeedMeta,
        weatherWindSpeed.isAcceptableOrUnknown(
          data['weather_wind_speed']!,
          _weatherWindSpeedMeta,
        ),
      );
    }
    if (data.containsKey('weather_rain_probability')) {
      context.handle(
        _weatherRainProbabilityMeta,
        weatherRainProbability.isAcceptableOrUnknown(
          data['weather_rain_probability']!,
          _weatherRainProbabilityMeta,
        ),
      );
    }
    if (data.containsKey('weather_observed_at')) {
      context.handle(
        _weatherObservedAtMeta,
        weatherObservedAt.isAcceptableOrUnknown(
          data['weather_observed_at']!,
          _weatherObservedAtMeta,
        ),
      );
    }
    if (data.containsKey('areas_covered')) {
      context.handle(
        _areasCoveredMeta,
        areasCovered.isAcceptableOrUnknown(
          data['areas_covered']!,
          _areasCoveredMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Journey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Journey(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mode'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      activeDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_duration_seconds'],
      )!,
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      )!,
      averageSpeedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_speed_kmh'],
      )!,
      maxSpeedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed_kmh'],
      )!,
      startLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_latitude'],
      ),
      startLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_longitude'],
      ),
      endLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}end_latitude'],
      ),
      endLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}end_longitude'],
      ),
      weatherTemperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weather_temperature'],
      ),
      weatherCondition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weather_condition'],
      ),
      weatherHumidity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weather_humidity'],
      ),
      weatherWindSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weather_wind_speed'],
      ),
      weatherRainProbability: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weather_rain_probability'],
      ),
      weatherObservedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}weather_observed_at'],
      ),
      areasCovered: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}areas_covered'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $JourneysTable createAlias(String alias) {
    return $JourneysTable(attachedDatabase, alias);
  }
}

class Journey extends DataClass implements Insertable<Journey> {
  final String id;
  final int mode;
  final DateTime startTime;
  final DateTime endTime;
  final int activeDurationSeconds;
  final double distanceMeters;
  final double averageSpeedKmh;
  final double maxSpeedKmh;
  final double? startLatitude;
  final double? startLongitude;
  final double? endLatitude;
  final double? endLongitude;
  final double? weatherTemperature;
  final String? weatherCondition;
  final int? weatherHumidity;
  final double? weatherWindSpeed;
  final int? weatherRainProbability;
  final DateTime? weatherObservedAt;
  final String areasCovered;
  final DateTime createdAt;
  const Journey({
    required this.id,
    required this.mode,
    required this.startTime,
    required this.endTime,
    required this.activeDurationSeconds,
    required this.distanceMeters,
    required this.averageSpeedKmh,
    required this.maxSpeedKmh,
    this.startLatitude,
    this.startLongitude,
    this.endLatitude,
    this.endLongitude,
    this.weatherTemperature,
    this.weatherCondition,
    this.weatherHumidity,
    this.weatherWindSpeed,
    this.weatherRainProbability,
    this.weatherObservedAt,
    required this.areasCovered,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mode'] = Variable<int>(mode);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['active_duration_seconds'] = Variable<int>(activeDurationSeconds);
    map['distance_meters'] = Variable<double>(distanceMeters);
    map['average_speed_kmh'] = Variable<double>(averageSpeedKmh);
    map['max_speed_kmh'] = Variable<double>(maxSpeedKmh);
    if (!nullToAbsent || startLatitude != null) {
      map['start_latitude'] = Variable<double>(startLatitude);
    }
    if (!nullToAbsent || startLongitude != null) {
      map['start_longitude'] = Variable<double>(startLongitude);
    }
    if (!nullToAbsent || endLatitude != null) {
      map['end_latitude'] = Variable<double>(endLatitude);
    }
    if (!nullToAbsent || endLongitude != null) {
      map['end_longitude'] = Variable<double>(endLongitude);
    }
    if (!nullToAbsent || weatherTemperature != null) {
      map['weather_temperature'] = Variable<double>(weatherTemperature);
    }
    if (!nullToAbsent || weatherCondition != null) {
      map['weather_condition'] = Variable<String>(weatherCondition);
    }
    if (!nullToAbsent || weatherHumidity != null) {
      map['weather_humidity'] = Variable<int>(weatherHumidity);
    }
    if (!nullToAbsent || weatherWindSpeed != null) {
      map['weather_wind_speed'] = Variable<double>(weatherWindSpeed);
    }
    if (!nullToAbsent || weatherRainProbability != null) {
      map['weather_rain_probability'] = Variable<int>(weatherRainProbability);
    }
    if (!nullToAbsent || weatherObservedAt != null) {
      map['weather_observed_at'] = Variable<DateTime>(weatherObservedAt);
    }
    map['areas_covered'] = Variable<String>(areasCovered);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  JourneysCompanion toCompanion(bool nullToAbsent) {
    return JourneysCompanion(
      id: Value(id),
      mode: Value(mode),
      startTime: Value(startTime),
      endTime: Value(endTime),
      activeDurationSeconds: Value(activeDurationSeconds),
      distanceMeters: Value(distanceMeters),
      averageSpeedKmh: Value(averageSpeedKmh),
      maxSpeedKmh: Value(maxSpeedKmh),
      startLatitude: startLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(startLatitude),
      startLongitude: startLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(startLongitude),
      endLatitude: endLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(endLatitude),
      endLongitude: endLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(endLongitude),
      weatherTemperature: weatherTemperature == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherTemperature),
      weatherCondition: weatherCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherCondition),
      weatherHumidity: weatherHumidity == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherHumidity),
      weatherWindSpeed: weatherWindSpeed == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherWindSpeed),
      weatherRainProbability: weatherRainProbability == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherRainProbability),
      weatherObservedAt: weatherObservedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherObservedAt),
      areasCovered: Value(areasCovered),
      createdAt: Value(createdAt),
    );
  }

  factory Journey.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Journey(
      id: serializer.fromJson<String>(json['id']),
      mode: serializer.fromJson<int>(json['mode']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      activeDurationSeconds: serializer.fromJson<int>(
        json['activeDurationSeconds'],
      ),
      distanceMeters: serializer.fromJson<double>(json['distanceMeters']),
      averageSpeedKmh: serializer.fromJson<double>(json['averageSpeedKmh']),
      maxSpeedKmh: serializer.fromJson<double>(json['maxSpeedKmh']),
      startLatitude: serializer.fromJson<double?>(json['startLatitude']),
      startLongitude: serializer.fromJson<double?>(json['startLongitude']),
      endLatitude: serializer.fromJson<double?>(json['endLatitude']),
      endLongitude: serializer.fromJson<double?>(json['endLongitude']),
      weatherTemperature: serializer.fromJson<double?>(
        json['weatherTemperature'],
      ),
      weatherCondition: serializer.fromJson<String?>(json['weatherCondition']),
      weatherHumidity: serializer.fromJson<int?>(json['weatherHumidity']),
      weatherWindSpeed: serializer.fromJson<double?>(json['weatherWindSpeed']),
      weatherRainProbability: serializer.fromJson<int?>(
        json['weatherRainProbability'],
      ),
      weatherObservedAt: serializer.fromJson<DateTime?>(
        json['weatherObservedAt'],
      ),
      areasCovered: serializer.fromJson<String>(json['areasCovered']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mode': serializer.toJson<int>(mode),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'activeDurationSeconds': serializer.toJson<int>(activeDurationSeconds),
      'distanceMeters': serializer.toJson<double>(distanceMeters),
      'averageSpeedKmh': serializer.toJson<double>(averageSpeedKmh),
      'maxSpeedKmh': serializer.toJson<double>(maxSpeedKmh),
      'startLatitude': serializer.toJson<double?>(startLatitude),
      'startLongitude': serializer.toJson<double?>(startLongitude),
      'endLatitude': serializer.toJson<double?>(endLatitude),
      'endLongitude': serializer.toJson<double?>(endLongitude),
      'weatherTemperature': serializer.toJson<double?>(weatherTemperature),
      'weatherCondition': serializer.toJson<String?>(weatherCondition),
      'weatherHumidity': serializer.toJson<int?>(weatherHumidity),
      'weatherWindSpeed': serializer.toJson<double?>(weatherWindSpeed),
      'weatherRainProbability': serializer.toJson<int?>(weatherRainProbability),
      'weatherObservedAt': serializer.toJson<DateTime?>(weatherObservedAt),
      'areasCovered': serializer.toJson<String>(areasCovered),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Journey copyWith({
    String? id,
    int? mode,
    DateTime? startTime,
    DateTime? endTime,
    int? activeDurationSeconds,
    double? distanceMeters,
    double? averageSpeedKmh,
    double? maxSpeedKmh,
    Value<double?> startLatitude = const Value.absent(),
    Value<double?> startLongitude = const Value.absent(),
    Value<double?> endLatitude = const Value.absent(),
    Value<double?> endLongitude = const Value.absent(),
    Value<double?> weatherTemperature = const Value.absent(),
    Value<String?> weatherCondition = const Value.absent(),
    Value<int?> weatherHumidity = const Value.absent(),
    Value<double?> weatherWindSpeed = const Value.absent(),
    Value<int?> weatherRainProbability = const Value.absent(),
    Value<DateTime?> weatherObservedAt = const Value.absent(),
    String? areasCovered,
    DateTime? createdAt,
  }) => Journey(
    id: id ?? this.id,
    mode: mode ?? this.mode,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    activeDurationSeconds: activeDurationSeconds ?? this.activeDurationSeconds,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
    maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
    startLatitude: startLatitude.present
        ? startLatitude.value
        : this.startLatitude,
    startLongitude: startLongitude.present
        ? startLongitude.value
        : this.startLongitude,
    endLatitude: endLatitude.present ? endLatitude.value : this.endLatitude,
    endLongitude: endLongitude.present ? endLongitude.value : this.endLongitude,
    weatherTemperature: weatherTemperature.present
        ? weatherTemperature.value
        : this.weatherTemperature,
    weatherCondition: weatherCondition.present
        ? weatherCondition.value
        : this.weatherCondition,
    weatherHumidity: weatherHumidity.present
        ? weatherHumidity.value
        : this.weatherHumidity,
    weatherWindSpeed: weatherWindSpeed.present
        ? weatherWindSpeed.value
        : this.weatherWindSpeed,
    weatherRainProbability: weatherRainProbability.present
        ? weatherRainProbability.value
        : this.weatherRainProbability,
    weatherObservedAt: weatherObservedAt.present
        ? weatherObservedAt.value
        : this.weatherObservedAt,
    areasCovered: areasCovered ?? this.areasCovered,
    createdAt: createdAt ?? this.createdAt,
  );
  Journey copyWithCompanion(JourneysCompanion data) {
    return Journey(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      activeDurationSeconds: data.activeDurationSeconds.present
          ? data.activeDurationSeconds.value
          : this.activeDurationSeconds,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      averageSpeedKmh: data.averageSpeedKmh.present
          ? data.averageSpeedKmh.value
          : this.averageSpeedKmh,
      maxSpeedKmh: data.maxSpeedKmh.present
          ? data.maxSpeedKmh.value
          : this.maxSpeedKmh,
      startLatitude: data.startLatitude.present
          ? data.startLatitude.value
          : this.startLatitude,
      startLongitude: data.startLongitude.present
          ? data.startLongitude.value
          : this.startLongitude,
      endLatitude: data.endLatitude.present
          ? data.endLatitude.value
          : this.endLatitude,
      endLongitude: data.endLongitude.present
          ? data.endLongitude.value
          : this.endLongitude,
      weatherTemperature: data.weatherTemperature.present
          ? data.weatherTemperature.value
          : this.weatherTemperature,
      weatherCondition: data.weatherCondition.present
          ? data.weatherCondition.value
          : this.weatherCondition,
      weatherHumidity: data.weatherHumidity.present
          ? data.weatherHumidity.value
          : this.weatherHumidity,
      weatherWindSpeed: data.weatherWindSpeed.present
          ? data.weatherWindSpeed.value
          : this.weatherWindSpeed,
      weatherRainProbability: data.weatherRainProbability.present
          ? data.weatherRainProbability.value
          : this.weatherRainProbability,
      weatherObservedAt: data.weatherObservedAt.present
          ? data.weatherObservedAt.value
          : this.weatherObservedAt,
      areasCovered: data.areasCovered.present
          ? data.areasCovered.value
          : this.areasCovered,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Journey(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('activeDurationSeconds: $activeDurationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('averageSpeedKmh: $averageSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('startLatitude: $startLatitude, ')
          ..write('startLongitude: $startLongitude, ')
          ..write('endLatitude: $endLatitude, ')
          ..write('endLongitude: $endLongitude, ')
          ..write('weatherTemperature: $weatherTemperature, ')
          ..write('weatherCondition: $weatherCondition, ')
          ..write('weatherHumidity: $weatherHumidity, ')
          ..write('weatherWindSpeed: $weatherWindSpeed, ')
          ..write('weatherRainProbability: $weatherRainProbability, ')
          ..write('weatherObservedAt: $weatherObservedAt, ')
          ..write('areasCovered: $areasCovered, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mode,
    startTime,
    endTime,
    activeDurationSeconds,
    distanceMeters,
    averageSpeedKmh,
    maxSpeedKmh,
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
    weatherTemperature,
    weatherCondition,
    weatherHumidity,
    weatherWindSpeed,
    weatherRainProbability,
    weatherObservedAt,
    areasCovered,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Journey &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.activeDurationSeconds == this.activeDurationSeconds &&
          other.distanceMeters == this.distanceMeters &&
          other.averageSpeedKmh == this.averageSpeedKmh &&
          other.maxSpeedKmh == this.maxSpeedKmh &&
          other.startLatitude == this.startLatitude &&
          other.startLongitude == this.startLongitude &&
          other.endLatitude == this.endLatitude &&
          other.endLongitude == this.endLongitude &&
          other.weatherTemperature == this.weatherTemperature &&
          other.weatherCondition == this.weatherCondition &&
          other.weatherHumidity == this.weatherHumidity &&
          other.weatherWindSpeed == this.weatherWindSpeed &&
          other.weatherRainProbability == this.weatherRainProbability &&
          other.weatherObservedAt == this.weatherObservedAt &&
          other.areasCovered == this.areasCovered &&
          other.createdAt == this.createdAt);
}

class JourneysCompanion extends UpdateCompanion<Journey> {
  final Value<String> id;
  final Value<int> mode;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> activeDurationSeconds;
  final Value<double> distanceMeters;
  final Value<double> averageSpeedKmh;
  final Value<double> maxSpeedKmh;
  final Value<double?> startLatitude;
  final Value<double?> startLongitude;
  final Value<double?> endLatitude;
  final Value<double?> endLongitude;
  final Value<double?> weatherTemperature;
  final Value<String?> weatherCondition;
  final Value<int?> weatherHumidity;
  final Value<double?> weatherWindSpeed;
  final Value<int?> weatherRainProbability;
  final Value<DateTime?> weatherObservedAt;
  final Value<String> areasCovered;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const JourneysCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.activeDurationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.averageSpeedKmh = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.startLatitude = const Value.absent(),
    this.startLongitude = const Value.absent(),
    this.endLatitude = const Value.absent(),
    this.endLongitude = const Value.absent(),
    this.weatherTemperature = const Value.absent(),
    this.weatherCondition = const Value.absent(),
    this.weatherHumidity = const Value.absent(),
    this.weatherWindSpeed = const Value.absent(),
    this.weatherRainProbability = const Value.absent(),
    this.weatherObservedAt = const Value.absent(),
    this.areasCovered = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JourneysCompanion.insert({
    required String id,
    required int mode,
    required DateTime startTime,
    required DateTime endTime,
    required int activeDurationSeconds,
    required double distanceMeters,
    required double averageSpeedKmh,
    required double maxSpeedKmh,
    this.startLatitude = const Value.absent(),
    this.startLongitude = const Value.absent(),
    this.endLatitude = const Value.absent(),
    this.endLongitude = const Value.absent(),
    this.weatherTemperature = const Value.absent(),
    this.weatherCondition = const Value.absent(),
    this.weatherHumidity = const Value.absent(),
    this.weatherWindSpeed = const Value.absent(),
    this.weatherRainProbability = const Value.absent(),
    this.weatherObservedAt = const Value.absent(),
    this.areasCovered = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mode = Value(mode),
       startTime = Value(startTime),
       endTime = Value(endTime),
       activeDurationSeconds = Value(activeDurationSeconds),
       distanceMeters = Value(distanceMeters),
       averageSpeedKmh = Value(averageSpeedKmh),
       maxSpeedKmh = Value(maxSpeedKmh);
  static Insertable<Journey> custom({
    Expression<String>? id,
    Expression<int>? mode,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? activeDurationSeconds,
    Expression<double>? distanceMeters,
    Expression<double>? averageSpeedKmh,
    Expression<double>? maxSpeedKmh,
    Expression<double>? startLatitude,
    Expression<double>? startLongitude,
    Expression<double>? endLatitude,
    Expression<double>? endLongitude,
    Expression<double>? weatherTemperature,
    Expression<String>? weatherCondition,
    Expression<int>? weatherHumidity,
    Expression<double>? weatherWindSpeed,
    Expression<int>? weatherRainProbability,
    Expression<DateTime>? weatherObservedAt,
    Expression<String>? areasCovered,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (activeDurationSeconds != null)
        'active_duration_seconds': activeDurationSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (averageSpeedKmh != null) 'average_speed_kmh': averageSpeedKmh,
      if (maxSpeedKmh != null) 'max_speed_kmh': maxSpeedKmh,
      if (startLatitude != null) 'start_latitude': startLatitude,
      if (startLongitude != null) 'start_longitude': startLongitude,
      if (endLatitude != null) 'end_latitude': endLatitude,
      if (endLongitude != null) 'end_longitude': endLongitude,
      if (weatherTemperature != null) 'weather_temperature': weatherTemperature,
      if (weatherCondition != null) 'weather_condition': weatherCondition,
      if (weatherHumidity != null) 'weather_humidity': weatherHumidity,
      if (weatherWindSpeed != null) 'weather_wind_speed': weatherWindSpeed,
      if (weatherRainProbability != null)
        'weather_rain_probability': weatherRainProbability,
      if (weatherObservedAt != null) 'weather_observed_at': weatherObservedAt,
      if (areasCovered != null) 'areas_covered': areasCovered,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JourneysCompanion copyWith({
    Value<String>? id,
    Value<int>? mode,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<int>? activeDurationSeconds,
    Value<double>? distanceMeters,
    Value<double>? averageSpeedKmh,
    Value<double>? maxSpeedKmh,
    Value<double?>? startLatitude,
    Value<double?>? startLongitude,
    Value<double?>? endLatitude,
    Value<double?>? endLongitude,
    Value<double?>? weatherTemperature,
    Value<String?>? weatherCondition,
    Value<int?>? weatherHumidity,
    Value<double?>? weatherWindSpeed,
    Value<int?>? weatherRainProbability,
    Value<DateTime?>? weatherObservedAt,
    Value<String>? areasCovered,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return JourneysCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      activeDurationSeconds:
          activeDurationSeconds ?? this.activeDurationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      endLatitude: endLatitude ?? this.endLatitude,
      endLongitude: endLongitude ?? this.endLongitude,
      weatherTemperature: weatherTemperature ?? this.weatherTemperature,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      weatherHumidity: weatherHumidity ?? this.weatherHumidity,
      weatherWindSpeed: weatherWindSpeed ?? this.weatherWindSpeed,
      weatherRainProbability:
          weatherRainProbability ?? this.weatherRainProbability,
      weatherObservedAt: weatherObservedAt ?? this.weatherObservedAt,
      areasCovered: areasCovered ?? this.areasCovered,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(mode.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (activeDurationSeconds.present) {
      map['active_duration_seconds'] = Variable<int>(
        activeDurationSeconds.value,
      );
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (averageSpeedKmh.present) {
      map['average_speed_kmh'] = Variable<double>(averageSpeedKmh.value);
    }
    if (maxSpeedKmh.present) {
      map['max_speed_kmh'] = Variable<double>(maxSpeedKmh.value);
    }
    if (startLatitude.present) {
      map['start_latitude'] = Variable<double>(startLatitude.value);
    }
    if (startLongitude.present) {
      map['start_longitude'] = Variable<double>(startLongitude.value);
    }
    if (endLatitude.present) {
      map['end_latitude'] = Variable<double>(endLatitude.value);
    }
    if (endLongitude.present) {
      map['end_longitude'] = Variable<double>(endLongitude.value);
    }
    if (weatherTemperature.present) {
      map['weather_temperature'] = Variable<double>(weatherTemperature.value);
    }
    if (weatherCondition.present) {
      map['weather_condition'] = Variable<String>(weatherCondition.value);
    }
    if (weatherHumidity.present) {
      map['weather_humidity'] = Variable<int>(weatherHumidity.value);
    }
    if (weatherWindSpeed.present) {
      map['weather_wind_speed'] = Variable<double>(weatherWindSpeed.value);
    }
    if (weatherRainProbability.present) {
      map['weather_rain_probability'] = Variable<int>(
        weatherRainProbability.value,
      );
    }
    if (weatherObservedAt.present) {
      map['weather_observed_at'] = Variable<DateTime>(weatherObservedAt.value);
    }
    if (areasCovered.present) {
      map['areas_covered'] = Variable<String>(areasCovered.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JourneysCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('activeDurationSeconds: $activeDurationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('averageSpeedKmh: $averageSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('startLatitude: $startLatitude, ')
          ..write('startLongitude: $startLongitude, ')
          ..write('endLatitude: $endLatitude, ')
          ..write('endLongitude: $endLongitude, ')
          ..write('weatherTemperature: $weatherTemperature, ')
          ..write('weatherCondition: $weatherCondition, ')
          ..write('weatherHumidity: $weatherHumidity, ')
          ..write('weatherWindSpeed: $weatherWindSpeed, ')
          ..write('weatherRainProbability: $weatherRainProbability, ')
          ..write('weatherObservedAt: $weatherObservedAt, ')
          ..write('areasCovered: $areasCovered, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JourneyPointsTable extends JourneyPoints
    with TableInfo<$JourneyPointsTable, JourneyPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JourneyPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _journeyIdMeta = const VerificationMeta(
    'journeyId',
  );
  @override
  late final GeneratedColumn<String> journeyId = GeneratedColumn<String>(
    'journey_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journeys (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedKmhMeta = const VerificationMeta(
    'speedKmh',
  );
  @override
  late final GeneratedColumn<double> speedKmh = GeneratedColumn<double>(
    'speed_kmh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _accuracyMetersMeta = const VerificationMeta(
    'accuracyMeters',
  );
  @override
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
    'accuracy_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _headingMeta = const VerificationMeta(
    'heading',
  );
  @override
  late final GeneratedColumn<double> heading = GeneratedColumn<double>(
    'heading',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    journeyId,
    latitude,
    longitude,
    timestamp,
    speedKmh,
    accuracyMeters,
    heading,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journey_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<JourneyPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('journey_id')) {
      context.handle(
        _journeyIdMeta,
        journeyId.isAcceptableOrUnknown(data['journey_id']!, _journeyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_journeyIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('speed_kmh')) {
      context.handle(
        _speedKmhMeta,
        speedKmh.isAcceptableOrUnknown(data['speed_kmh']!, _speedKmhMeta),
      );
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
        _accuracyMetersMeta,
        accuracyMeters.isAcceptableOrUnknown(
          data['accuracy_meters']!,
          _accuracyMetersMeta,
        ),
      );
    }
    if (data.containsKey('heading')) {
      context.handle(
        _headingMeta,
        heading.isAcceptableOrUnknown(data['heading']!, _headingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JourneyPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JourneyPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      journeyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journey_id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      speedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_kmh'],
      )!,
      accuracyMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_meters'],
      )!,
      heading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading'],
      ),
    );
  }

  @override
  $JourneyPointsTable createAlias(String alias) {
    return $JourneyPointsTable(attachedDatabase, alias);
  }
}

class JourneyPoint extends DataClass implements Insertable<JourneyPoint> {
  final int id;
  final String journeyId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double speedKmh;
  final double accuracyMeters;
  final double? heading;
  const JourneyPoint({
    required this.id,
    required this.journeyId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.speedKmh,
    required this.accuracyMeters,
    this.heading,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['journey_id'] = Variable<String>(journeyId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['speed_kmh'] = Variable<double>(speedKmh);
    map['accuracy_meters'] = Variable<double>(accuracyMeters);
    if (!nullToAbsent || heading != null) {
      map['heading'] = Variable<double>(heading);
    }
    return map;
  }

  JourneyPointsCompanion toCompanion(bool nullToAbsent) {
    return JourneyPointsCompanion(
      id: Value(id),
      journeyId: Value(journeyId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      timestamp: Value(timestamp),
      speedKmh: Value(speedKmh),
      accuracyMeters: Value(accuracyMeters),
      heading: heading == null && nullToAbsent
          ? const Value.absent()
          : Value(heading),
    );
  }

  factory JourneyPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JourneyPoint(
      id: serializer.fromJson<int>(json['id']),
      journeyId: serializer.fromJson<String>(json['journeyId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      speedKmh: serializer.fromJson<double>(json['speedKmh']),
      accuracyMeters: serializer.fromJson<double>(json['accuracyMeters']),
      heading: serializer.fromJson<double?>(json['heading']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'journeyId': serializer.toJson<String>(journeyId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'speedKmh': serializer.toJson<double>(speedKmh),
      'accuracyMeters': serializer.toJson<double>(accuracyMeters),
      'heading': serializer.toJson<double?>(heading),
    };
  }

  JourneyPoint copyWith({
    int? id,
    String? journeyId,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    double? speedKmh,
    double? accuracyMeters,
    Value<double?> heading = const Value.absent(),
  }) => JourneyPoint(
    id: id ?? this.id,
    journeyId: journeyId ?? this.journeyId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    timestamp: timestamp ?? this.timestamp,
    speedKmh: speedKmh ?? this.speedKmh,
    accuracyMeters: accuracyMeters ?? this.accuracyMeters,
    heading: heading.present ? heading.value : this.heading,
  );
  JourneyPoint copyWithCompanion(JourneyPointsCompanion data) {
    return JourneyPoint(
      id: data.id.present ? data.id.value : this.id,
      journeyId: data.journeyId.present ? data.journeyId.value : this.journeyId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      speedKmh: data.speedKmh.present ? data.speedKmh.value : this.speedKmh,
      accuracyMeters: data.accuracyMeters.present
          ? data.accuracyMeters.value
          : this.accuracyMeters,
      heading: data.heading.present ? data.heading.value : this.heading,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JourneyPoint(')
          ..write('id: $id, ')
          ..write('journeyId: $journeyId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timestamp: $timestamp, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('heading: $heading')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    journeyId,
    latitude,
    longitude,
    timestamp,
    speedKmh,
    accuracyMeters,
    heading,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JourneyPoint &&
          other.id == this.id &&
          other.journeyId == this.journeyId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.timestamp == this.timestamp &&
          other.speedKmh == this.speedKmh &&
          other.accuracyMeters == this.accuracyMeters &&
          other.heading == this.heading);
}

class JourneyPointsCompanion extends UpdateCompanion<JourneyPoint> {
  final Value<int> id;
  final Value<String> journeyId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> timestamp;
  final Value<double> speedKmh;
  final Value<double> accuracyMeters;
  final Value<double?> heading;
  const JourneyPointsCompanion({
    this.id = const Value.absent(),
    this.journeyId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.heading = const Value.absent(),
  });
  JourneyPointsCompanion.insert({
    this.id = const Value.absent(),
    required String journeyId,
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    this.speedKmh = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.heading = const Value.absent(),
  }) : journeyId = Value(journeyId),
       latitude = Value(latitude),
       longitude = Value(longitude),
       timestamp = Value(timestamp);
  static Insertable<JourneyPoint> custom({
    Expression<int>? id,
    Expression<String>? journeyId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? timestamp,
    Expression<double>? speedKmh,
    Expression<double>? accuracyMeters,
    Expression<double>? heading,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journeyId != null) 'journey_id': journeyId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (timestamp != null) 'timestamp': timestamp,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (heading != null) 'heading': heading,
    });
  }

  JourneyPointsCompanion copyWith({
    Value<int>? id,
    Value<String>? journeyId,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<DateTime>? timestamp,
    Value<double>? speedKmh,
    Value<double>? accuracyMeters,
    Value<double?>? heading,
  }) {
    return JourneyPointsCompanion(
      id: id ?? this.id,
      journeyId: journeyId ?? this.journeyId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      speedKmh: speedKmh ?? this.speedKmh,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      heading: heading ?? this.heading,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (journeyId.present) {
      map['journey_id'] = Variable<String>(journeyId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (speedKmh.present) {
      map['speed_kmh'] = Variable<double>(speedKmh.value);
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (heading.present) {
      map['heading'] = Variable<double>(heading.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JourneyPointsCompanion(')
          ..write('id: $id, ')
          ..write('journeyId: $journeyId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timestamp: $timestamp, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('heading: $heading')
          ..write(')'))
        .toString();
  }
}

class $ActiveJourneysTable extends ActiveJourneys
    with TableInfo<$ActiveJourneysTable, ActiveJourney> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveJourneysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<int> mode = GeneratedColumn<int>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeDurationSecondsMeta =
      const VerificationMeta('activeDurationSeconds');
  @override
  late final GeneratedColumn<int> activeDurationSeconds = GeneratedColumn<int>(
    'active_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxSpeedKmhMeta = const VerificationMeta(
    'maxSpeedKmh',
  );
  @override
  late final GeneratedColumn<double> maxSpeedKmh = GeneratedColumn<double>(
    'max_speed_kmh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPausedMeta = const VerificationMeta(
    'isPaused',
  );
  @override
  late final GeneratedColumn<bool> isPaused = GeneratedColumn<bool>(
    'is_paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pausedAtMeta = const VerificationMeta(
    'pausedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pausedAt = GeneratedColumn<DateTime>(
    'paused_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    startTime,
    activeDurationSeconds,
    distanceMeters,
    maxSpeedKmh,
    isPaused,
    pausedAt,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_journeys';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveJourney> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('active_duration_seconds')) {
      context.handle(
        _activeDurationSecondsMeta,
        activeDurationSeconds.isAcceptableOrUnknown(
          data['active_duration_seconds']!,
          _activeDurationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeDurationSecondsMeta);
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanceMetersMeta);
    }
    if (data.containsKey('max_speed_kmh')) {
      context.handle(
        _maxSpeedKmhMeta,
        maxSpeedKmh.isAcceptableOrUnknown(
          data['max_speed_kmh']!,
          _maxSpeedKmhMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxSpeedKmhMeta);
    }
    if (data.containsKey('is_paused')) {
      context.handle(
        _isPausedMeta,
        isPaused.isAcceptableOrUnknown(data['is_paused']!, _isPausedMeta),
      );
    }
    if (data.containsKey('paused_at')) {
      context.handle(
        _pausedAtMeta,
        pausedAt.isAcceptableOrUnknown(data['paused_at']!, _pausedAtMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveJourney map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveJourney(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mode'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      activeDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_duration_seconds'],
      )!,
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      )!,
      maxSpeedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed_kmh'],
      )!,
      isPaused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paused'],
      )!,
      pausedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paused_at'],
      ),
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $ActiveJourneysTable createAlias(String alias) {
    return $ActiveJourneysTable(attachedDatabase, alias);
  }
}

class ActiveJourney extends DataClass implements Insertable<ActiveJourney> {
  final String id;
  final int mode;
  final DateTime startTime;
  final int activeDurationSeconds;
  final double distanceMeters;
  final double maxSpeedKmh;
  final bool isPaused;
  final DateTime? pausedAt;
  final DateTime lastUpdated;
  const ActiveJourney({
    required this.id,
    required this.mode,
    required this.startTime,
    required this.activeDurationSeconds,
    required this.distanceMeters,
    required this.maxSpeedKmh,
    required this.isPaused,
    this.pausedAt,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mode'] = Variable<int>(mode);
    map['start_time'] = Variable<DateTime>(startTime);
    map['active_duration_seconds'] = Variable<int>(activeDurationSeconds);
    map['distance_meters'] = Variable<double>(distanceMeters);
    map['max_speed_kmh'] = Variable<double>(maxSpeedKmh);
    map['is_paused'] = Variable<bool>(isPaused);
    if (!nullToAbsent || pausedAt != null) {
      map['paused_at'] = Variable<DateTime>(pausedAt);
    }
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  ActiveJourneysCompanion toCompanion(bool nullToAbsent) {
    return ActiveJourneysCompanion(
      id: Value(id),
      mode: Value(mode),
      startTime: Value(startTime),
      activeDurationSeconds: Value(activeDurationSeconds),
      distanceMeters: Value(distanceMeters),
      maxSpeedKmh: Value(maxSpeedKmh),
      isPaused: Value(isPaused),
      pausedAt: pausedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pausedAt),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory ActiveJourney.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveJourney(
      id: serializer.fromJson<String>(json['id']),
      mode: serializer.fromJson<int>(json['mode']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      activeDurationSeconds: serializer.fromJson<int>(
        json['activeDurationSeconds'],
      ),
      distanceMeters: serializer.fromJson<double>(json['distanceMeters']),
      maxSpeedKmh: serializer.fromJson<double>(json['maxSpeedKmh']),
      isPaused: serializer.fromJson<bool>(json['isPaused']),
      pausedAt: serializer.fromJson<DateTime?>(json['pausedAt']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mode': serializer.toJson<int>(mode),
      'startTime': serializer.toJson<DateTime>(startTime),
      'activeDurationSeconds': serializer.toJson<int>(activeDurationSeconds),
      'distanceMeters': serializer.toJson<double>(distanceMeters),
      'maxSpeedKmh': serializer.toJson<double>(maxSpeedKmh),
      'isPaused': serializer.toJson<bool>(isPaused),
      'pausedAt': serializer.toJson<DateTime?>(pausedAt),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  ActiveJourney copyWith({
    String? id,
    int? mode,
    DateTime? startTime,
    int? activeDurationSeconds,
    double? distanceMeters,
    double? maxSpeedKmh,
    bool? isPaused,
    Value<DateTime?> pausedAt = const Value.absent(),
    DateTime? lastUpdated,
  }) => ActiveJourney(
    id: id ?? this.id,
    mode: mode ?? this.mode,
    startTime: startTime ?? this.startTime,
    activeDurationSeconds: activeDurationSeconds ?? this.activeDurationSeconds,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
    isPaused: isPaused ?? this.isPaused,
    pausedAt: pausedAt.present ? pausedAt.value : this.pausedAt,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  ActiveJourney copyWithCompanion(ActiveJourneysCompanion data) {
    return ActiveJourney(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      activeDurationSeconds: data.activeDurationSeconds.present
          ? data.activeDurationSeconds.value
          : this.activeDurationSeconds,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      maxSpeedKmh: data.maxSpeedKmh.present
          ? data.maxSpeedKmh.value
          : this.maxSpeedKmh,
      isPaused: data.isPaused.present ? data.isPaused.value : this.isPaused,
      pausedAt: data.pausedAt.present ? data.pausedAt.value : this.pausedAt,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveJourney(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('startTime: $startTime, ')
          ..write('activeDurationSeconds: $activeDurationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('isPaused: $isPaused, ')
          ..write('pausedAt: $pausedAt, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mode,
    startTime,
    activeDurationSeconds,
    distanceMeters,
    maxSpeedKmh,
    isPaused,
    pausedAt,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveJourney &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.startTime == this.startTime &&
          other.activeDurationSeconds == this.activeDurationSeconds &&
          other.distanceMeters == this.distanceMeters &&
          other.maxSpeedKmh == this.maxSpeedKmh &&
          other.isPaused == this.isPaused &&
          other.pausedAt == this.pausedAt &&
          other.lastUpdated == this.lastUpdated);
}

class ActiveJourneysCompanion extends UpdateCompanion<ActiveJourney> {
  final Value<String> id;
  final Value<int> mode;
  final Value<DateTime> startTime;
  final Value<int> activeDurationSeconds;
  final Value<double> distanceMeters;
  final Value<double> maxSpeedKmh;
  final Value<bool> isPaused;
  final Value<DateTime?> pausedAt;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const ActiveJourneysCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.startTime = const Value.absent(),
    this.activeDurationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.pausedAt = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveJourneysCompanion.insert({
    required String id,
    required int mode,
    required DateTime startTime,
    required int activeDurationSeconds,
    required double distanceMeters,
    required double maxSpeedKmh,
    this.isPaused = const Value.absent(),
    this.pausedAt = const Value.absent(),
    required DateTime lastUpdated,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mode = Value(mode),
       startTime = Value(startTime),
       activeDurationSeconds = Value(activeDurationSeconds),
       distanceMeters = Value(distanceMeters),
       maxSpeedKmh = Value(maxSpeedKmh),
       lastUpdated = Value(lastUpdated);
  static Insertable<ActiveJourney> custom({
    Expression<String>? id,
    Expression<int>? mode,
    Expression<DateTime>? startTime,
    Expression<int>? activeDurationSeconds,
    Expression<double>? distanceMeters,
    Expression<double>? maxSpeedKmh,
    Expression<bool>? isPaused,
    Expression<DateTime>? pausedAt,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (startTime != null) 'start_time': startTime,
      if (activeDurationSeconds != null)
        'active_duration_seconds': activeDurationSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (maxSpeedKmh != null) 'max_speed_kmh': maxSpeedKmh,
      if (isPaused != null) 'is_paused': isPaused,
      if (pausedAt != null) 'paused_at': pausedAt,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveJourneysCompanion copyWith({
    Value<String>? id,
    Value<int>? mode,
    Value<DateTime>? startTime,
    Value<int>? activeDurationSeconds,
    Value<double>? distanceMeters,
    Value<double>? maxSpeedKmh,
    Value<bool>? isPaused,
    Value<DateTime?>? pausedAt,
    Value<DateTime>? lastUpdated,
    Value<int>? rowid,
  }) {
    return ActiveJourneysCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      startTime: startTime ?? this.startTime,
      activeDurationSeconds:
          activeDurationSeconds ?? this.activeDurationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      isPaused: isPaused ?? this.isPaused,
      pausedAt: pausedAt ?? this.pausedAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(mode.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (activeDurationSeconds.present) {
      map['active_duration_seconds'] = Variable<int>(
        activeDurationSeconds.value,
      );
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (maxSpeedKmh.present) {
      map['max_speed_kmh'] = Variable<double>(maxSpeedKmh.value);
    }
    if (isPaused.present) {
      map['is_paused'] = Variable<bool>(isPaused.value);
    }
    if (pausedAt.present) {
      map['paused_at'] = Variable<DateTime>(pausedAt.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveJourneysCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('startTime: $startTime, ')
          ..write('activeDurationSeconds: $activeDurationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('isPaused: $isPaused, ')
          ..write('pausedAt: $pausedAt, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $JourneysTable journeys = $JourneysTable(this);
  late final $JourneyPointsTable journeyPoints = $JourneyPointsTable(this);
  late final $ActiveJourneysTable activeJourneys = $ActiveJourneysTable(this);
  late final JourneysDao journeysDao = JourneysDao(this as AppDatabase);
  late final PointsDao pointsDao = PointsDao(this as AppDatabase);
  late final ActiveJourneyDao activeJourneyDao = ActiveJourneyDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    journeys,
    journeyPoints,
    activeJourneys,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'journeys',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('journey_points', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$JourneysTableCreateCompanionBuilder =
    JourneysCompanion Function({
      required String id,
      required int mode,
      required DateTime startTime,
      required DateTime endTime,
      required int activeDurationSeconds,
      required double distanceMeters,
      required double averageSpeedKmh,
      required double maxSpeedKmh,
      Value<double?> startLatitude,
      Value<double?> startLongitude,
      Value<double?> endLatitude,
      Value<double?> endLongitude,
      Value<double?> weatherTemperature,
      Value<String?> weatherCondition,
      Value<int?> weatherHumidity,
      Value<double?> weatherWindSpeed,
      Value<int?> weatherRainProbability,
      Value<DateTime?> weatherObservedAt,
      Value<String> areasCovered,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$JourneysTableUpdateCompanionBuilder =
    JourneysCompanion Function({
      Value<String> id,
      Value<int> mode,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<int> activeDurationSeconds,
      Value<double> distanceMeters,
      Value<double> averageSpeedKmh,
      Value<double> maxSpeedKmh,
      Value<double?> startLatitude,
      Value<double?> startLongitude,
      Value<double?> endLatitude,
      Value<double?> endLongitude,
      Value<double?> weatherTemperature,
      Value<String?> weatherCondition,
      Value<int?> weatherHumidity,
      Value<double?> weatherWindSpeed,
      Value<int?> weatherRainProbability,
      Value<DateTime?> weatherObservedAt,
      Value<String> areasCovered,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$JourneysTableReferences
    extends BaseReferences<_$AppDatabase, $JourneysTable, Journey> {
  $$JourneysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JourneyPointsTable, List<JourneyPoint>>
  _journeyPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journeyPoints,
    aliasName: $_aliasNameGenerator(db.journeys.id, db.journeyPoints.journeyId),
  );

  $$JourneyPointsTableProcessedTableManager get journeyPointsRefs {
    final manager = $$JourneyPointsTableTableManager(
      $_db,
      $_db.journeyPoints,
    ).filter((f) => f.journeyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_journeyPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$JourneysTableFilterComposer
    extends Composer<_$AppDatabase, $JourneysTable> {
  $$JourneysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeDurationSeconds => $composableBuilder(
    column: $table.activeDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startLatitude => $composableBuilder(
    column: $table.startLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startLongitude => $composableBuilder(
    column: $table.startLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get endLatitude => $composableBuilder(
    column: $table.endLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get endLongitude => $composableBuilder(
    column: $table.endLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weatherTemperature => $composableBuilder(
    column: $table.weatherTemperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weatherCondition => $composableBuilder(
    column: $table.weatherCondition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weatherHumidity => $composableBuilder(
    column: $table.weatherHumidity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weatherWindSpeed => $composableBuilder(
    column: $table.weatherWindSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weatherRainProbability => $composableBuilder(
    column: $table.weatherRainProbability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weatherObservedAt => $composableBuilder(
    column: $table.weatherObservedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get areasCovered => $composableBuilder(
    column: $table.areasCovered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> journeyPointsRefs(
    Expression<bool> Function($$JourneyPointsTableFilterComposer f) f,
  ) {
    final $$JourneyPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journeyPoints,
      getReferencedColumn: (t) => t.journeyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneyPointsTableFilterComposer(
            $db: $db,
            $table: $db.journeyPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JourneysTableOrderingComposer
    extends Composer<_$AppDatabase, $JourneysTable> {
  $$JourneysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeDurationSeconds => $composableBuilder(
    column: $table.activeDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startLatitude => $composableBuilder(
    column: $table.startLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startLongitude => $composableBuilder(
    column: $table.startLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get endLatitude => $composableBuilder(
    column: $table.endLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get endLongitude => $composableBuilder(
    column: $table.endLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weatherTemperature => $composableBuilder(
    column: $table.weatherTemperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weatherCondition => $composableBuilder(
    column: $table.weatherCondition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weatherHumidity => $composableBuilder(
    column: $table.weatherHumidity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weatherWindSpeed => $composableBuilder(
    column: $table.weatherWindSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weatherRainProbability => $composableBuilder(
    column: $table.weatherRainProbability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weatherObservedAt => $composableBuilder(
    column: $table.weatherObservedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get areasCovered => $composableBuilder(
    column: $table.areasCovered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JourneysTableAnnotationComposer
    extends Composer<_$AppDatabase, $JourneysTable> {
  $$JourneysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get activeDurationSeconds => $composableBuilder(
    column: $table.activeDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => column,
  );

  GeneratedColumn<double> get startLatitude => $composableBuilder(
    column: $table.startLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get startLongitude => $composableBuilder(
    column: $table.startLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get endLatitude => $composableBuilder(
    column: $table.endLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get endLongitude => $composableBuilder(
    column: $table.endLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weatherTemperature => $composableBuilder(
    column: $table.weatherTemperature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weatherCondition => $composableBuilder(
    column: $table.weatherCondition,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weatherHumidity => $composableBuilder(
    column: $table.weatherHumidity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weatherWindSpeed => $composableBuilder(
    column: $table.weatherWindSpeed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weatherRainProbability => $composableBuilder(
    column: $table.weatherRainProbability,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get weatherObservedAt => $composableBuilder(
    column: $table.weatherObservedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get areasCovered => $composableBuilder(
    column: $table.areasCovered,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> journeyPointsRefs<T extends Object>(
    Expression<T> Function($$JourneyPointsTableAnnotationComposer a) f,
  ) {
    final $$JourneyPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journeyPoints,
      getReferencedColumn: (t) => t.journeyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneyPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.journeyPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JourneysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JourneysTable,
          Journey,
          $$JourneysTableFilterComposer,
          $$JourneysTableOrderingComposer,
          $$JourneysTableAnnotationComposer,
          $$JourneysTableCreateCompanionBuilder,
          $$JourneysTableUpdateCompanionBuilder,
          (Journey, $$JourneysTableReferences),
          Journey,
          PrefetchHooks Function({bool journeyPointsRefs})
        > {
  $$JourneysTableTableManager(_$AppDatabase db, $JourneysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JourneysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JourneysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JourneysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> mode = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<int> activeDurationSeconds = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<double> averageSpeedKmh = const Value.absent(),
                Value<double> maxSpeedKmh = const Value.absent(),
                Value<double?> startLatitude = const Value.absent(),
                Value<double?> startLongitude = const Value.absent(),
                Value<double?> endLatitude = const Value.absent(),
                Value<double?> endLongitude = const Value.absent(),
                Value<double?> weatherTemperature = const Value.absent(),
                Value<String?> weatherCondition = const Value.absent(),
                Value<int?> weatherHumidity = const Value.absent(),
                Value<double?> weatherWindSpeed = const Value.absent(),
                Value<int?> weatherRainProbability = const Value.absent(),
                Value<DateTime?> weatherObservedAt = const Value.absent(),
                Value<String> areasCovered = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JourneysCompanion(
                id: id,
                mode: mode,
                startTime: startTime,
                endTime: endTime,
                activeDurationSeconds: activeDurationSeconds,
                distanceMeters: distanceMeters,
                averageSpeedKmh: averageSpeedKmh,
                maxSpeedKmh: maxSpeedKmh,
                startLatitude: startLatitude,
                startLongitude: startLongitude,
                endLatitude: endLatitude,
                endLongitude: endLongitude,
                weatherTemperature: weatherTemperature,
                weatherCondition: weatherCondition,
                weatherHumidity: weatherHumidity,
                weatherWindSpeed: weatherWindSpeed,
                weatherRainProbability: weatherRainProbability,
                weatherObservedAt: weatherObservedAt,
                areasCovered: areasCovered,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int mode,
                required DateTime startTime,
                required DateTime endTime,
                required int activeDurationSeconds,
                required double distanceMeters,
                required double averageSpeedKmh,
                required double maxSpeedKmh,
                Value<double?> startLatitude = const Value.absent(),
                Value<double?> startLongitude = const Value.absent(),
                Value<double?> endLatitude = const Value.absent(),
                Value<double?> endLongitude = const Value.absent(),
                Value<double?> weatherTemperature = const Value.absent(),
                Value<String?> weatherCondition = const Value.absent(),
                Value<int?> weatherHumidity = const Value.absent(),
                Value<double?> weatherWindSpeed = const Value.absent(),
                Value<int?> weatherRainProbability = const Value.absent(),
                Value<DateTime?> weatherObservedAt = const Value.absent(),
                Value<String> areasCovered = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JourneysCompanion.insert(
                id: id,
                mode: mode,
                startTime: startTime,
                endTime: endTime,
                activeDurationSeconds: activeDurationSeconds,
                distanceMeters: distanceMeters,
                averageSpeedKmh: averageSpeedKmh,
                maxSpeedKmh: maxSpeedKmh,
                startLatitude: startLatitude,
                startLongitude: startLongitude,
                endLatitude: endLatitude,
                endLongitude: endLongitude,
                weatherTemperature: weatherTemperature,
                weatherCondition: weatherCondition,
                weatherHumidity: weatherHumidity,
                weatherWindSpeed: weatherWindSpeed,
                weatherRainProbability: weatherRainProbability,
                weatherObservedAt: weatherObservedAt,
                areasCovered: areasCovered,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JourneysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journeyPointsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (journeyPointsRefs) db.journeyPoints,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journeyPointsRefs)
                    await $_getPrefetchedData<
                      Journey,
                      $JourneysTable,
                      JourneyPoint
                    >(
                      currentTable: table,
                      referencedTable: $$JourneysTableReferences
                          ._journeyPointsRefsTable(db),
                      managerFromTypedResult: (p0) => $$JourneysTableReferences(
                        db,
                        table,
                        p0,
                      ).journeyPointsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.journeyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$JourneysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JourneysTable,
      Journey,
      $$JourneysTableFilterComposer,
      $$JourneysTableOrderingComposer,
      $$JourneysTableAnnotationComposer,
      $$JourneysTableCreateCompanionBuilder,
      $$JourneysTableUpdateCompanionBuilder,
      (Journey, $$JourneysTableReferences),
      Journey,
      PrefetchHooks Function({bool journeyPointsRefs})
    >;
typedef $$JourneyPointsTableCreateCompanionBuilder =
    JourneyPointsCompanion Function({
      Value<int> id,
      required String journeyId,
      required double latitude,
      required double longitude,
      required DateTime timestamp,
      Value<double> speedKmh,
      Value<double> accuracyMeters,
      Value<double?> heading,
    });
typedef $$JourneyPointsTableUpdateCompanionBuilder =
    JourneyPointsCompanion Function({
      Value<int> id,
      Value<String> journeyId,
      Value<double> latitude,
      Value<double> longitude,
      Value<DateTime> timestamp,
      Value<double> speedKmh,
      Value<double> accuracyMeters,
      Value<double?> heading,
    });

final class $$JourneyPointsTableReferences
    extends BaseReferences<_$AppDatabase, $JourneyPointsTable, JourneyPoint> {
  $$JourneyPointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JourneysTable _journeyIdTable(_$AppDatabase db) =>
      db.journeys.createAlias(
        $_aliasNameGenerator(db.journeyPoints.journeyId, db.journeys.id),
      );

  $$JourneysTableProcessedTableManager get journeyId {
    final $_column = $_itemColumn<String>('journey_id')!;

    final manager = $$JourneysTableTableManager(
      $_db,
      $_db.journeys,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_journeyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JourneyPointsTableFilterComposer
    extends Composer<_$AppDatabase, $JourneyPointsTable> {
  $$JourneyPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnFilters(column),
  );

  $$JourneysTableFilterComposer get journeyId {
    final $$JourneysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journeyId,
      referencedTable: $db.journeys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneysTableFilterComposer(
            $db: $db,
            $table: $db.journeys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JourneyPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $JourneyPointsTable> {
  $$JourneyPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnOrderings(column),
  );

  $$JourneysTableOrderingComposer get journeyId {
    final $$JourneysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journeyId,
      referencedTable: $db.journeys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneysTableOrderingComposer(
            $db: $db,
            $table: $db.journeys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JourneyPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JourneyPointsTable> {
  $$JourneyPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get speedKmh =>
      $composableBuilder(column: $table.speedKmh, builder: (column) => column);

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heading =>
      $composableBuilder(column: $table.heading, builder: (column) => column);

  $$JourneysTableAnnotationComposer get journeyId {
    final $$JourneysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journeyId,
      referencedTable: $db.journeys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneysTableAnnotationComposer(
            $db: $db,
            $table: $db.journeys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JourneyPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JourneyPointsTable,
          JourneyPoint,
          $$JourneyPointsTableFilterComposer,
          $$JourneyPointsTableOrderingComposer,
          $$JourneyPointsTableAnnotationComposer,
          $$JourneyPointsTableCreateCompanionBuilder,
          $$JourneyPointsTableUpdateCompanionBuilder,
          (JourneyPoint, $$JourneyPointsTableReferences),
          JourneyPoint,
          PrefetchHooks Function({bool journeyId})
        > {
  $$JourneyPointsTableTableManager(_$AppDatabase db, $JourneyPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JourneyPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JourneyPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JourneyPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> journeyId = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> speedKmh = const Value.absent(),
                Value<double> accuracyMeters = const Value.absent(),
                Value<double?> heading = const Value.absent(),
              }) => JourneyPointsCompanion(
                id: id,
                journeyId: journeyId,
                latitude: latitude,
                longitude: longitude,
                timestamp: timestamp,
                speedKmh: speedKmh,
                accuracyMeters: accuracyMeters,
                heading: heading,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String journeyId,
                required double latitude,
                required double longitude,
                required DateTime timestamp,
                Value<double> speedKmh = const Value.absent(),
                Value<double> accuracyMeters = const Value.absent(),
                Value<double?> heading = const Value.absent(),
              }) => JourneyPointsCompanion.insert(
                id: id,
                journeyId: journeyId,
                latitude: latitude,
                longitude: longitude,
                timestamp: timestamp,
                speedKmh: speedKmh,
                accuracyMeters: accuracyMeters,
                heading: heading,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JourneyPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journeyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (journeyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.journeyId,
                                referencedTable: $$JourneyPointsTableReferences
                                    ._journeyIdTable(db),
                                referencedColumn: $$JourneyPointsTableReferences
                                    ._journeyIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JourneyPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JourneyPointsTable,
      JourneyPoint,
      $$JourneyPointsTableFilterComposer,
      $$JourneyPointsTableOrderingComposer,
      $$JourneyPointsTableAnnotationComposer,
      $$JourneyPointsTableCreateCompanionBuilder,
      $$JourneyPointsTableUpdateCompanionBuilder,
      (JourneyPoint, $$JourneyPointsTableReferences),
      JourneyPoint,
      PrefetchHooks Function({bool journeyId})
    >;
typedef $$ActiveJourneysTableCreateCompanionBuilder =
    ActiveJourneysCompanion Function({
      required String id,
      required int mode,
      required DateTime startTime,
      required int activeDurationSeconds,
      required double distanceMeters,
      required double maxSpeedKmh,
      Value<bool> isPaused,
      Value<DateTime?> pausedAt,
      required DateTime lastUpdated,
      Value<int> rowid,
    });
typedef $$ActiveJourneysTableUpdateCompanionBuilder =
    ActiveJourneysCompanion Function({
      Value<String> id,
      Value<int> mode,
      Value<DateTime> startTime,
      Value<int> activeDurationSeconds,
      Value<double> distanceMeters,
      Value<double> maxSpeedKmh,
      Value<bool> isPaused,
      Value<DateTime?> pausedAt,
      Value<DateTime> lastUpdated,
      Value<int> rowid,
    });

class $$ActiveJourneysTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveJourneysTable> {
  $$ActiveJourneysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeDurationSeconds => $composableBuilder(
    column: $table.activeDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pausedAt => $composableBuilder(
    column: $table.pausedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveJourneysTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveJourneysTable> {
  $$ActiveJourneysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeDurationSeconds => $composableBuilder(
    column: $table.activeDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pausedAt => $composableBuilder(
    column: $table.pausedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveJourneysTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveJourneysTable> {
  $$ActiveJourneysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get activeDurationSeconds => $composableBuilder(
    column: $table.activeDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaused =>
      $composableBuilder(column: $table.isPaused, builder: (column) => column);

  GeneratedColumn<DateTime> get pausedAt =>
      $composableBuilder(column: $table.pausedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$ActiveJourneysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveJourneysTable,
          ActiveJourney,
          $$ActiveJourneysTableFilterComposer,
          $$ActiveJourneysTableOrderingComposer,
          $$ActiveJourneysTableAnnotationComposer,
          $$ActiveJourneysTableCreateCompanionBuilder,
          $$ActiveJourneysTableUpdateCompanionBuilder,
          (
            ActiveJourney,
            BaseReferences<_$AppDatabase, $ActiveJourneysTable, ActiveJourney>,
          ),
          ActiveJourney,
          PrefetchHooks Function()
        > {
  $$ActiveJourneysTableTableManager(
    _$AppDatabase db,
    $ActiveJourneysTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveJourneysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveJourneysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveJourneysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> mode = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<int> activeDurationSeconds = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<double> maxSpeedKmh = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<DateTime?> pausedAt = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveJourneysCompanion(
                id: id,
                mode: mode,
                startTime: startTime,
                activeDurationSeconds: activeDurationSeconds,
                distanceMeters: distanceMeters,
                maxSpeedKmh: maxSpeedKmh,
                isPaused: isPaused,
                pausedAt: pausedAt,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int mode,
                required DateTime startTime,
                required int activeDurationSeconds,
                required double distanceMeters,
                required double maxSpeedKmh,
                Value<bool> isPaused = const Value.absent(),
                Value<DateTime?> pausedAt = const Value.absent(),
                required DateTime lastUpdated,
                Value<int> rowid = const Value.absent(),
              }) => ActiveJourneysCompanion.insert(
                id: id,
                mode: mode,
                startTime: startTime,
                activeDurationSeconds: activeDurationSeconds,
                distanceMeters: distanceMeters,
                maxSpeedKmh: maxSpeedKmh,
                isPaused: isPaused,
                pausedAt: pausedAt,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveJourneysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveJourneysTable,
      ActiveJourney,
      $$ActiveJourneysTableFilterComposer,
      $$ActiveJourneysTableOrderingComposer,
      $$ActiveJourneysTableAnnotationComposer,
      $$ActiveJourneysTableCreateCompanionBuilder,
      $$ActiveJourneysTableUpdateCompanionBuilder,
      (
        ActiveJourney,
        BaseReferences<_$AppDatabase, $ActiveJourneysTable, ActiveJourney>,
      ),
      ActiveJourney,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$JourneysTableTableManager get journeys =>
      $$JourneysTableTableManager(_db, _db.journeys);
  $$JourneyPointsTableTableManager get journeyPoints =>
      $$JourneyPointsTableTableManager(_db, _db.journeyPoints);
  $$ActiveJourneysTableTableManager get activeJourneys =>
      $$ActiveJourneysTableTableManager(_db, _db.activeJourneys);
}
