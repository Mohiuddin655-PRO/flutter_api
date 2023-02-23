import 'dart:developer';

import 'package:flutter_api/feature/domain/entities/entity.dart';

class Address {
  final String? street;
  final String? suite;
  final String? city;
  final String? zipcode;
  final Geo? geo;

  const Address({
    this.street,
    this.suite,
    this.city,
    this.zipcode,
    this.geo,
  });

  factory Address.from(dynamic data) {
    dynamic street, suite, city, zipcode, geo;
    if (data is Map) {
      try {
        street = data['street'];
        suite = data['suite'];
        city = data['city'];
        zipcode = data['zipcode'];
        geo = data['geo'];
      } catch (e) {
        log(e.toString());
      }
    }
    return Address(
      street: street is String ? street : null,
      suite: suite is String ? suite : null,
      city: city is String ? city : null,
      zipcode: zipcode is String ? zipcode : null,
      geo: Geo.from(geo),
    );
  }

  Map<String, dynamic> get source {
    return {
      "street": street,
      "suite": suite,
      "city": city,
      "zipcode": zipcode,
      "geo": geo?.source,
    };
  }

  Address copyWith({
    String? street,
    String? suite,
    String? city,
    String? zipcode,
    Geo? geo,
  }) {
    return Address(
      street: street ?? this.street,
      suite: suite ?? this.suite,
      city: city ?? this.city,
      zipcode: zipcode ?? this.zipcode,
      geo: geo ?? this.geo,
    );
  }
}

class Geo {
  final String? lat;
  final String? lng;

  const Geo({
    this.lat,
    this.lng,
  });

  factory Geo.from(dynamic data) {
    dynamic lat, lng;
    if (data is Map) {
      try {
        lat = data['lat'];
        lng = data['lng'];
      } catch (e) {
        log(e.toString());
      }
    }
    return Geo(
      lat: lat is String ? lat : null,
      lng: lng is String ? lng : null,
    );
  }

  Map<String, dynamic> get source {
    return {
      "lat": lat,
      "lng": lng,
    };
  }

  Geo copyWith({
    String? lat,
    String? lng,
  }) {
    return Geo(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

class Company {
  final String? name;
  final String? catchPhrase;
  final String? bs;

  const Company({
    this.name,
    this.catchPhrase,
    this.bs,
  });

  factory Company.from(dynamic data) {
    dynamic name, catchPhrase, bs;
    if (data is Map) {
      try {
        name = data['name'];
        catchPhrase = data['catchPhrase'];
        bs = data['bs'];
      } catch (e) {
        log(e.toString());
      }
    }
    return Company(
      name: name is String ? name : null,
      catchPhrase: catchPhrase is String ? catchPhrase : null,
      bs: bs is String ? bs : null,
    );
  }

  Map<String, dynamic> get source {
    return {
      "name": name,
      "catchPhrase": catchPhrase,
      "bs": bs,
    };
  }

  Company copyWith({
    String? name,
    String? catchPhrase,
    String? bs,
  }) {
    return Company(
      name: name ?? this.name,
      catchPhrase: catchPhrase ?? this.catchPhrase,
      bs: bs ?? this.bs,
    );
  }
}

class User extends Entity {
  final String? name;
  final String? username;
  final String? email;
  final Address? address;
  final String? phone;
  final String? website;
  final Company? company;

  const User({
    super.id,
    this.name,
    this.username,
    this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  User copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    Address? address,
    String? phone,
    String? website,
    Company? company,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      company: company ?? this.company,
    );
  }

  factory User.from(dynamic data) {
    dynamic id, name, username, email, address, phone, website, company;
    if (data is Map) {
      try {
        id = data['id'];
        name = data['name'];
        username = data['username'];
        email = data['email'];
        address = data['address'];
        phone = data['phone'];
        website = data['website'];
        company = data['company'];
        return User(
          id: id is int ? id : null,
          name: name is String ? name : null,
          username: username is String ? username : null,
          email: email is String ? email : null,
          address: Address.from(address),
          phone: phone is String ? phone : null,
          website: website is String ? website : null,
          company: Company.from(company),
        );
      } catch (e) {
        log(e.toString());
      }
    }
    return const User();
  }

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "name": name,
      "username": username,
      "email": email,
      "address": address?.source,
      "phone": phone,
      "website": website,
      "company": company?.source,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        email,
        address?.source,
        phone,
        website,
        company?.source,
      ];
}
