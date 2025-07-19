CREATE DATABASE bd_collaborax CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bd_collaborax;

create table archivos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre varchar(255) NOT NULL,
  ruta varchar(255) NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

create table roles (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre varchar(255) NOT NULL,
  descripcion varchar(255) NOT NULL,
  activo tinyint(1) NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

create table usuarios (
  id INT PRIMARY KEY AUTO_INCREMENT,
  correo varchar(255) UNIQUE NOT NULL,
  correo_personal varchar(255) UNIQUE NOT NULL,
  clave varchar(255) NOT NULL,
  rol_id INT NOT NULL,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  en_linea tinyint(1) NOT NULL,
  ultima_conexion TIMESTAMP NULL,
  foto INT NULL,
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  clave_mostrar varchar(255) NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (rol_id) REFERENCES roles(id),
  FOREIGN KEY (foto) REFERENCES archivos(id)
);



create table plan_servicios (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre varchar(255),
  beneficios TEXT,
  costo_soles double NOT NULL,
  cant_usuarios INT NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

create table empresas(
  id INT PRIMARY KEY AUTO_INCREMENT,
  usuario_id INT NOT NULL,
  plan_servicio_id INT NOT NULL,
  nombre varchar(255) NOT NULL,
  descripcion varchar(255) NULL,
  ruc varchar(255) NOT NULL,
  telefono varchar (255) NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (plan_servicio_id) REFERENCES plan_servicios(id)
);

create table trabajadores (
  id INT PRIMARY KEY AUTO_INCREMENT,
  usuario_id INT NOT NULL,
  empresa_id INT NOT NULL,
  nombres varchar(255) NOT NULL,
  apellido_paterno varchar(255) NOT NULL,
  apellido_materno varchar(255) NOT NULL,
  doc_identidad varchar(8) NULL,
  fecha_nacimiento TIMESTAMP NULL,
  telefono varchar (255) NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);

create table areas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  empresa_id INT NOT NULL,
  nombre varchar(255) NOT NULL,
  descripcion varchar(255) NULL,
  codigo varchar(255) NOT NULL,
  color varchar(255) NULL,
  activo tinyint(1) NOT NULL,
  fecha_creacion TIMESTAMP DEFAULT current_timestamp NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);

create table equipos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  coordinador_id INT NOT NULL,
  area_id INT NOT NULL,
  nombre varchar(255) NOT NULL,
  descripcion varchar(255) NULL,
  fecha_creacion TIMESTAMP DEFAULT current_timestamp NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,  
  FOREIGN KEY (coordinador_id) REFERENCES trabajadores(id),
  FOREIGN KEY (area_id) REFERENCES areas(id)
);

create table miembros_equipo (
  id INT PRIMARY KEY AUTO_INCREMENT,
  equipo_id INT NOT NULL,
  trabajador_id INT NOT NULL,
  fecha_union TIMESTAMP DEFAULT current_timestamp NOT NULL,
  activo tinyint(1) NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (equipo_id) REFERENCES equipos(id),
  FOREIGN KEY (trabajador_id) REFERENCES trabajadores(id)
);

create table estados (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre varchar(255) NOT NULL,
  descripcion varchar(255) NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

create table metas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  equipo_id INT NOT NULL,
  estado_id INT NOT NULL,
  nombre varchar(255) NOT NULL,
  descripcion varchar(255) NULL,
  fecha_creacion TIMESTAMP DEFAULT current_timestamp NOT NULL,
  fecha_entrega TIMESTAMP NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (equipo_id) REFERENCES equipos(id),
  FOREIGN KEY (estado_id) REFERENCES estados(id)
);

create table tareas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  meta_id INT NOT NULL,
  estado_id INT NOT NULL,
  nombre varchar(255) NOT NULL,
  descripcion varchar(255) NULL,
  fecha_creacion TIMESTAMP DEFAULT current_timestamp NOT NULL,
  fecha_entrega TIMESTAMP NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (meta_id) REFERENCES metas(id),
  FOREIGN KEY (estado_id) REFERENCES estados(id)
);

create table modalidades (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre varchar(255) NOT NULL,
  descripcion varchar(255) NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

create table reuniones (
  id INT PRIMARY KEY AUTO_INCREMENT,
  equipo_id INT NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NULL,
  duracion int NOT NULL,
  descripcion varchar(255) NULL,
  asunto varchar(255) NOT NULL,
  modalidad_id INT NOT NULL,
  sala varchar(255) NULL,
  estado varchar(255) NOT NULL default 'PROGRAMADA',
  observacion varchar(255) NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (equipo_id) REFERENCES equipos(id),
  FOREIGN KEY (modalidad_id) REFERENCES modalidades(id)
);

create table areas_coordinador (
  id INT PRIMARY KEY AUTO_INCREMENT,
  area_id INT NOT NULL,
  trabajador_id INT NOT NULL,
  fecha_inicio TIMESTAMP NOT NULL,
  fecha_fin TIMESTAMP NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (area_id) REFERENCES areas(id),
  FOREIGN KEY (trabajador_id) REFERENCES trabajadores(id)
);

create table invitaciones (
  id INT PRIMARY KEY AUTO_INCREMENT,
  equipo_id INT NOT NULL,
  trabajador_id INT NOT NULL,
  fecha_invitacion TIMESTAMP DEFAULT current_timestamp,
  fecha_expiracion TIMESTAMP NULL,
  fecha_respuesta TIMESTAMP NULL,
  estado varchar(255) NOT NULL DEFAULT 'PENDIENTE',
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (equipo_id) REFERENCES equipos(id),
  FOREIGN KEY (trabajador_id) REFERENCES trabajadores(id)
);

create table mensajes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  remitente_id INT NOT NULL,
  destinatario_id INT NOT NULL,
  contenido TEXT NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  leido tinyint(1) NOT NULL,
  archivo_id INT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  FOREIGN KEY (remitente_id) REFERENCES trabajadores(id),
  FOREIGN KEY (destinatario_id) REFERENCES trabajadores(id),
  FOREIGN KEY (archivo_id) REFERENCES archivos(id)
);

-- 1. Archivos (15 registros)
INSERT INTO archivos (nombre, ruta) VALUES
('perfil_carlos.jpg', '/uploads/perfil_carlos.jpg'),
('manual_usuario.pdf',  '/uploads/manual_usuario.pdf'),
('logo_empresa.png',  '/uploads/logo_empresa.png'),
('presentacion_producto.pptx', '/uploads/presentacion_producto.pptx'),
('grafico_ventas.svg','/uploads/grafico_ventas.svg'),
('contrato_template.docx','/uploads/contrato_template.docx'),
('video_intro.mp4','/uploads/video_intro.mp4'),
('audio_notas.mp3','/uploads/audio_notas.mp3'),
('informe_finanzas.xlsx','/uploads/informe_finanzas.xlsx'),
('diagrama_procesos.vsdx','/uploads/diagrama_procesos.vsdx'),
('foto_evento.jpg','/uploads/foto_evento.jpg'),
('esquema_red.png','/uploads/esquema_red.png'),
('plan_marketing.docx','/uploads/plan_marketing.docx'),
('demo_app.mov','/uploads/demo_app.mov'),
('hoja_calculo_proyecto.xlsx','/uploads/hoja_calculo_proyecto.xlsx');

-- 2. Roles (5 registros)
INSERT INTO roles (nombre, descripcion, activo) VALUES
('Super Admin',   'Acceso total sin restricciones',        1),
('Admin',         'Gestión administrativa y de usuarios',  1),
('Coord. General','Supervisión y coordinación general',    1),
('Coord. Equipo', 'Liderazgo de equipos específicos',     1),
('Colaborador',   'Acceso limitado para colaboración',     1);

-- 3. Planes de servicio (3 registros)
INSERT INTO plan_servicios (nombre, beneficios, costo_soles, cant_usuarios) VALUES
('Standard',  'Funciones básicas de gestión y soporte email',       49.90,  5),
('Business',  'Incluye reportes avanzados y chat interno',         129.90, 20),
('Enterprise','Soporte 24/7, SLA garantizado y API ilimitada',    299.90,100);

-- 10. Estados (4 registros)
INSERT INTO estados (nombre, descripcion) VALUES
('Incompleta','Tarea o meta no iniciada'),
('En proceso','Actualmente en desarrollo'),
('Completo','Finalizado satisfactoriamente'),
('Suspendida','Pausada temporalmente');

-- 13. Modalidades (3 registros)
INSERT INTO modalidades (nombre, descripcion) VALUES
('Presencial','Reunión en sala física'),
('Virtual','Reunión por videoconferencia'),
('Híbrida','Combinación presencial y virtual');

INSERT INTO usuarios (correo, correo_personal, clave, rol_id, activo, en_linea, ultima_conexion, clave_mostrar, foto) VALUES
('superadmin@collaborax.com', 'superadmin@gmail.com',  '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 1, 1, 1, NOW(), null, 1)

INSERT INTO usuarios (correo, correo_personal, clave, rol_id, activo, en_linea, ultima_conexion, clave_mostrar, foto) VALUES
('admin1@empresa1.com',   'admin1.personal@gmail.com',   '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 2, 1, 0, NOW(), NULL, 1),
('coordgen1@empresa1.com','coordgen1.personal@gmail.com','$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 3, 1, 0, NOW(), NULL, 1),
('coordeq1@empresa1.com', 'coordeq1.personal@gmail.com', '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 4, 1, 0, NOW(), NULL, 1),
('coordeq2@empresa1.com', 'coordeq2.personal@gmail.com', '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 4, 1, 0, NOW(), NULL, 1),
('trab1@empresa1.com',    'trab1.personal@gmail.com',    '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 5, 1, 0, NOW(), NULL, 1),
('trab2@empresa1.com',    'trab2.personal@gmail.com',    '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 5, 1, 0, NOW(), NULL, 1),
('trab3@empresa1.com',    'trab3.personal@gmail.com',    '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 5, 1, 0, NOW(), NULL, 1);

-- 2️⃣ Usuarios de Empresa 2
INSERT INTO usuarios (correo, correo_personal, clave, rol_id, activo, en_linea, ultima_conexion, clave_mostrar, foto) VALUES
('admin1@empresa2.com',   'admin1.personal2@gmail.com',   '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 2, 1, 0, NOW(), NULL, 2),
('coordgen1@empresa2.com','coordgen1.personal2@gmail.com','$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 3, 1, 0, NOW(), NULL, 2),
('coordeq1@empresa2.com', 'coordeq1.personal2@gmail.com', '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 4, 1, 0, NOW(), NULL, 2),
('coordeq2@empresa2.com', 'coordeq2.personal2@gmail.com', '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 4, 1, 0, NOW(), NULL, 2),
('trab1@empresa2.com',    'trab1.personal2@gmail.com',    '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 5, 1, 0, NOW(), NULL, 2),
('trab2@empresa2.com',    'trab2.personal2@gmail.com',    '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 5, 1, 0, NOW(), NULL, 2),
('trab3@empresa2.com',    'trab3.personal2@gmail.com',    '$2y$12$Uy6eT8rFWhLDfPkfY31MkORzDdfVXWX2icYKSrmRKUPQ2lK9gS.My', 5, 1, 0, NOW(), NULL, 2);

-- 3️⃣ Empresas (vinculadas al usuario admin respectivo)
INSERT INTO empresas (usuario_id, plan_servicio_id, nombre, descripcion, ruc, telefono) VALUES
(2, 2, 'Empresa Innovadora S.A.C.', 'Consultoría y desarrollo de software', '20123456789', '999888777'),
(9, 1, 'Empresa Soluciones EIRL', 'Servicios de soporte técnico', '20456789123', '988777666');

-- 4️⃣ Trabajadores de Empresa 1 (Admin, coordinadores y colaboradores)
INSERT INTO trabajadores (usuario_id, empresa_id, nombres, apellido_paterno, apellido_materno, doc_identidad, fecha_nacimiento, telefono) VALUES
(2, 1, 'Ana', 'Pérez', 'García', '12345678', '1985-05-10', '999111222'),
(3, 1, 'Luis', 'Ramírez', 'Lopez', '23456789', '1980-02-20', '988111333'),
(4, 1, 'María', 'Díaz', 'Torres', '34567890', '1990-06-15', '977222333'),
(5, 1, 'Pedro', 'Suárez', 'Martínez', '45678901', '1992-08-25', '966333444'),
(6, 1, 'Carlos', 'Vera', 'Guzmán', '56789012', '1995-09-12', '955444555'),
(7, 1, 'Lucía', 'Fernández', 'Cruz', '67890123', '1998-11-30', '944555666'),
(8, 1, 'Jorge', 'Mendoza', 'Reyes', '78901234', '1996-03-03', '933666777');

-- 5️⃣ Trabajadores de Empresa 2
INSERT INTO trabajadores (usuario_id, empresa_id, nombres, apellido_paterno, apellido_materno, doc_identidad, fecha_nacimiento, telefono) VALUES
(9, 2, 'Paula', 'Cruz', 'Reyes', '11223344', '1987-04-14', '922111222'),
(10, 2, 'Miguel', 'Ortiz', 'Santos', '22334455', '1983-07-19', '911222333'),
(11, 2, 'Diana', 'Vega', 'Salazar', '33445566', '1991-12-05', '900333444'),
(12, 2, 'Oscar', 'Campos', 'Ruiz', '44556677', '1994-01-22', '899444555'),
(13, 2, 'Sofía', 'Gómez', 'Paredes', '55667788', '1997-10-18', '888555666'),
(14, 2, 'Renzo', 'Ponce', 'Zapata', '66778899', '1999-02-02', '877666777'),
(15, 2, 'Brenda', 'Ríos', 'Silva', '77889900', '1995-05-09', '866777888');
