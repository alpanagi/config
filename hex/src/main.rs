use std::time::SystemTime;

fn main() {
    let now = SystemTime::now();
    let timestamp = now.duration_since(SystemTime::UNIX_EPOCH).unwrap().as_secs();
    println!("{:X}", timestamp);
}
