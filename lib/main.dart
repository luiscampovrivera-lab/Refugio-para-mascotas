import 'package:flutter/material.dart';

void main() {
  runApp(const MiRefugioApp());
}

// ============================================================================
// 1. APLICACIÓN PRINCIPAL
// ============================================================================
class MiRefugioApp extends StatelessWidget {
  const MiRefugioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Refugio de Mascotas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const RefugioScreen(),
    );
  }
}

// ============================================================================
// 2. MODELO DE DATOS
// ============================================================================
class Mascota {
  final String nombre;
  final String raza;
  final String foto; // Ruta del asset
  final int edadMeses;
  final String tamano;
  final String descripcion;
  bool favorito;

  Mascota({
    required this.nombre,
    required this.raza,
    required this.foto,
    required this.edadMeses,
    required this.tamano,
    required this.descripcion,
    this.favorito = false,
  });
}

// ============================================================================
// 3. PANTALLA PRINCIPAL (STATEFULWIDGET)
// ============================================================================
class RefugioScreen extends StatefulWidget {
  const RefugioScreen({super.key});

  @override
  State<RefugioScreen> createState() => _RefugioScreenState();
}

class _RefugioScreenState extends State<RefugioScreen> {
  // LISTA DE MASCOTAS - TODAS CON EXTENSIÓN .jpeg
  final List<Mascota> mascotas = [
    Mascota(
      nombre: 'Castor',
      raza: 'Castor Americano',
      foto: 'images/Castor.jpeg',
      edadMeses: 18,
      tamano: 'Mediano',
      descripcion: 'Muy trabajador, le encanta nadar y construir refugios de madera.',
    ),
    Mascota(
      nombre: 'Gato Blanco',
      raza: 'Persa / Mestizo',
      foto: 'images/Gato1.jpeg',
      edadMeses: 12,
      tamano: 'Pequeño',
      descripcion: 'Un gatito blanco, tranquilo y bastante curioso. Le encanta estar acostado al sol.',
    ),
    Mascota(
      nombre: 'Gato Negro',
      raza: 'Bombay',
      foto: 'images/Gato2.jpeg',
      edadMeses: 15,
      tamano: 'Pequeño',
      descripcion: 'Un minino oscuro con grandes ojos brillantes. Es muy cariñoso y juguetón.',
    ),
    Mascota(
      nombre: 'Gato Naranja',
      raza: 'Atigrado / Tabby',
      foto: 'images/Gato3.jpeg',
      edadMeses: 8,
      tamano: 'Pequeño',
      descripcion: 'Súper enérgico y amigable, siempre listo para jugar con hilos y pelotas.',
    ),
    Mascota(
      nombre: 'Pato',
      raza: 'Pato Doméstico',
      foto: 'images/Pato.jpeg',
      edadMeses: 10,
      tamano: 'Pequeño',
      descripcion: 'Le encanta el agua, dar paseos al aire libre y graznar alegremente.',
    ),
    Mascota(
      nombre: 'Perro',
      raza: 'Mestizo',
      foto: 'images/Perro.jpeg',
      edadMeses: 24,
      tamano: 'Mediano',
      descripcion: 'Un gran compañero, leal, inteligente y perfecto para pasear por el parque.',
    ),
  ];

  String textoBusqueda = '';

  @override
  Widget build(BuildContext context) {
    // Filtrado lógico
    final mascotasFiltradas = mascotas.where((mascota) {
      final query = textoBusqueda.toLowerCase();
      return mascota.nombre.toLowerCase().contains(query) ||
          mascota.raza.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refugio de Mascotas'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o raza...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (val) {
                setState(() {
                  textoBusqueda = val;
                });
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              'Destacados para adopción',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // LISTA HORIZONTAL (Carrusel)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mascotas.length,
              itemBuilder: (context, index) {
                final mascota = mascotas[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleMascotaScreen(mascota: mascota),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        mascota.foto,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        // Muestra un ícono gris si la imagen falla
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.pets, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Todas las mascotas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // LISTA VERTICAL (Resultados)
          Expanded(
            child: mascotasFiltradas.isEmpty
                ? const Center(
                    child: Text('No se encontraron mascotas.'),
                  )
                : ListView.separated(
                    itemCount: mascotasFiltradas.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return _buildMascotaTile(mascotasFiltradas[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget para cada fila de la lista vertical
  Widget _buildMascotaTile(Mascota mascota) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: AssetImage(mascota.foto),
        backgroundColor: Colors.grey[200],
        // Manejo de error también en el Avatar
        foregroundImage: AssetImage(mascota.foto),
        onForegroundImageError: (exception, stackTrace) {
          // Si falla, el CircleAvatar usará su backgroundColor e hijo por defecto
        },
        child: const Icon(Icons.pets, color: Colors.grey),
      ),
      title: Text(
        mascota.nombre,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${mascota.raza} • ${mascota.edadMeses} meses'),
      trailing: IconButton(
        icon: Icon(
          mascota.favorito ? Icons.favorite : Icons.favorite_border,
          color: mascota.favorito ? Colors.red : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            mascota.favorito = !mascota.favorito;
          });
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleMascotaScreen(mascota: mascota),
          ),
        );
      },
    );
  }
}

// ============================================================================
// 4. PANTALLA DE DETALLE (STATELESSWIDGET)
// ============================================================================
class DetalleMascotaScreen extends StatelessWidget {
  final Mascota mascota;

  const DetalleMascotaScreen({super.key, required this.mascota});

  // Widget auxiliar para mostrar filas de datos
  Widget _buildDato(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$etiqueta: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mascota.nombre),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen grande con bordes redondeados
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                mascota.foto,
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 260,
                  color: Colors.grey[300],
                  child: const Icon(Icons.pets, size: 80, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Datos detallados
            _buildDato('Nombre', mascota.nombre),
            _buildDato('Raza', mascota.raza),
            _buildDato('Edad', '${mascota.edadMeses} meses'),
            _buildDato('Tamaño', mascota.tamano),
            _buildDato('Estado Favorito', mascota.favorito ? 'Sí' : 'No'),
            
            const Divider(height: 30),
            
            // Descripción
            const Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              mascota.descripcion,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
          ),
    );
  }
}