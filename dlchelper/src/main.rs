use std::fs;
use std::env;
use std::process::Command;

fn process_ncch_files(version: &str) -> Result<(), Box<dyn std::error::Error>> {
    let mut input_args = Vec::new();
    let mut file_prefix: Option<String> = None;
    for entry in fs::read_dir(".")? {
        let entry = entry?;
        let path = entry.path();

        if let Some(ext) = path.extension() {
            if ext == "ncch" {
                if let Some(filename) = path.file_stem().and_then(|s| s.to_str()) {
                    if let Some(last_dot) = filename.rfind('.') {
                        if let Some(second_last_dot) = filename[..last_dot].rfind('.') {
                            let prefix = &filename[..second_last_dot];
                            let index = &filename[second_last_dot + 1..last_dot];
                            let hex_value = &filename[last_dot + 1..];
                            let dec_value = u32::from_str_radix(hex_value, 16)?;

                            // Build sub arg (-i)
                            let input_arg = format!("{}.ncch:{}:{}", filename, index, dec_value);
                            input_args.push(input_arg);
                            if file_prefix.is_none() {
                                file_prefix = Some(prefix.to_string());
                            }
                        }
                    }
                }
            }
        }
    }

    if !input_args.is_empty() {
        if let Some(p) = file_prefix {
            let output_file = format!("{}_DLC_decrypted.cia", p);

            // Build args and run makerom
            let mut command = Command::new("makerom_x86.exe");
            command.args(&[
                "-f", "cia",
                "-dlc",
                "-ignoresign",
                "-target", "p",
            ]);

            for arg in input_args {
                command.args(&[
                    "-i", &arg,
                ]);
            }

            // Added -o and -ver
            command.args(&[
                "-o", &output_file,
            ]);
            command.arg("-ver");
            command.arg(&version);

            // Hide stdout and stderr
            // command.stdout(std::process::Stdio::null());
            // command.stderr(std::process::Stdio::null());

            let status = command.status()?;
            if status.success() {
                println!("Successfully executed makerom.");
            } else {
                eprintln!("Error executing makerom.");
            }
        }
    } else {
        eprintln!("No valid .ncch files found.");
    }

    Ok(())
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: dlchelper <version_number>");
        return;
    }

    let version = &args[1];

    if let Err(e) = process_ncch_files(version) {
        eprintln!("Error: {}", e);
    }
}
