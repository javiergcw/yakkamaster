import 'job_dto.dart';

class JobDetailsDto extends JobDto {
  final String company;
  final String address;
  final String suburb;
  final String city;
  final String startDate;
  final String time;
  final String paymentExpected;
  final String aboutJob;
  final List<String> requirements;
  final double latitude;
  final double longitude;

  JobDetailsDto({
    required super.id,
    required super.title,
    required super.hourlyRate,
    required super.location,
    required super.dateRange,
    required super.jobType,
    required super.source,
    required super.postedDate,
    super.isRecommended,
    required this.company,
    required this.address,
    required this.suburb,
    required this.city,
    required this.startDate,
    required this.time,
    required this.paymentExpected,
    required this.aboutJob,
    required this.requirements,
    required this.latitude,
    required this.longitude,
  });

  factory JobDetailsDto.fromJobDto(JobDto job) {
    return JobDetailsDto(
      id: job.id,
      title: job.title,
      hourlyRate: job.hourlyRate,
      location: job.location,
      dateRange: job.dateRange,
      jobType: job.jobType,
      source: job.source,
      postedDate: job.postedDate,
      isRecommended: job.isRecommended,
      company: job.source,
      address: job.location,
      suburb: job.location.split(', ').length > 2 ? job.location.split(', ')[2] : '',
      city: job.location.split(', ').length > 3 ? job.location.split(', ')[3] : '',
      startDate: job.dateRange,
      time: '8:30 AM - 4:00 PM',
      paymentExpected: 'Weekly payment',
      aboutJob: 'Don\'t need to bring anything just will be pressure washing driveways and cleaning peoples exterior of their homes. eg window washing house washing etc, super easy stuff!',
      requirements: [
        'Must be physically fit',
        'Reliable and punctual',
        'Previous experience preferred but not required',
        'Own transportation to site',
      ],
      latitude: -33.8688, // Sydney coordinates
      longitude: 151.2093,
    );
  }

  factory JobDetailsDto.fromJson(Map<String, dynamic> json) {
    return JobDetailsDto(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      hourlyRate: (json['hourlyRate'] ?? 0.0).toDouble(),
      location: json['location'] ?? '',
      dateRange: json['dateRange'] ?? '',
      jobType: json['jobType'] ?? '',
      source: json['source'] ?? '',
      postedDate: json['postedDate'] ?? '',
      isRecommended: json['isRecommended'] ?? false,
      company: json['company'] ?? '',
      address: json['address'] ?? '',
      suburb: json['suburb'] ?? '',
      city: json['city'] ?? '',
      startDate: json['startDate'] ?? '',
      time: json['time'] ?? '',
      paymentExpected: json['paymentExpected'] ?? '',
      aboutJob: json['aboutJob'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'company': company,
      'address': address,
      'suburb': suburb,
      'city': city,
      'startDate': startDate,
      'time': time,
      'paymentExpected': paymentExpected,
      'aboutJob': aboutJob,
      'requirements': requirements,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  JobDetailsDto copyWith({
    String? id,
    String? title,
    double? hourlyRate,
    String? location,
    String? dateRange,
    String? jobType,
    String? source,
    String? postedDate,
    bool? isRecommended,
    String? company,
    String? address,
    String? suburb,
    String? city,
    String? startDate,
    String? time,
    String? paymentExpected,
    String? aboutJob,
    List<String>? requirements,
    double? latitude,
    double? longitude,
  }) {
    return JobDetailsDto(
      id: id ?? this.id,
      title: title ?? this.title,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      location: location ?? this.location,
      dateRange: dateRange ?? this.dateRange,
      jobType: jobType ?? this.jobType,
      source: source ?? this.source,
      postedDate: postedDate ?? this.postedDate,
      isRecommended: isRecommended ?? this.isRecommended,
      company: company ?? this.company,
      address: address ?? this.address,
      suburb: suburb ?? this.suburb,
      city: city ?? this.city,
      startDate: startDate ?? this.startDate,
      time: time ?? this.time,
      paymentExpected: paymentExpected ?? this.paymentExpected,
      aboutJob: aboutJob ?? this.aboutJob,
      requirements: requirements ?? this.requirements,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
