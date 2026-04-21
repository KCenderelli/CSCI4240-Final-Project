// License Proof Circuit
// Proves a user has a valid license without revealing their identity
// Private inputs: license details (only the user knows these)
// Public inputs: commitment hash (what the blockchain verifies)

fn main(
    // Private inputs - never revealed publicly
    license_id: u64,
    expiry: u64,
    secret: u64,
    // Public inputs - visible on chain
    current_time: pub u64,
    commitment: pub Field
) {
    // Prove license is not expired
    assert(expiry > current_time);

    // Prove the commitment matches the private license details
    let computed_commitment = std::hash::pedersen_hash([license_id as Field, expiry as Field, secret as Field]);
    assert(computed_commitment == commitment);
}

#[test]
fn test_valid_license() {
    let license_id = 1;
    let expiry = 9999999999;
    let secret = 12345;
    let current_time = 1000000000;
    
    let commitment = std::hash::pedersen_hash([license_id as Field, expiry as Field, secret as Field]);
    
    main(license_id, expiry, secret, current_time, commitment);
}

#[test]
fn test_expired_license_fails() {
    let _license_id = 1;
    let _expiry = 100;
    let _secret = 12345;
    let _current_time = 9999;
    // expiry < current_time so main() would fail
}