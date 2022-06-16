<h1 align="center">SISTEM INFORMASI PEDOMAN AKADEMIK LINGKUP UPI</h1>
<h2 align="center">SIPALING-UPI</h2>

Anggota :   
* Farhan Nurzaman			      (1904908)   
* Ira Fitri Yani				    (1901280)   
* Muhamad Fadeellah Rizki		(1908653)   
* Muhammad Naufal Wicaksono	(1904802)   
* Yudi Prasetyo			        (1905348)   

## [Backend API](https://sipalingupi-api.herokuapp.com/)

## Get Fakultas List

```http
GET /faks
```

## Responses


```javascript
[
    {
        "id": "String",
        "nama": "String"
    }
]
```

## Get Prodi List

```http
GET /prodis
```

## Responses


```javascript
[
    {
        "id": "String",
        "fakId": "String"
    }
]
```

## Get IPK of fakultas List

```http
GET /faks/:nama_fak/ipks
```

## Get IPK of prodi List

```http
GET /prodis/:nama_prodi/ipks
```

## Get Keketatan of fakultas List

```http
GET /faks/:nama_fak/keketatans
```

## Get Keketatan of prodi List

```http
GET /prodis/:nama_prodi/keketatans
```